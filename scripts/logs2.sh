#!/bin/bash

# Configuración común
WORKSPACE_NAME="VM-Logs-Workspace"
LOCATION="westus"
SUBSCRIPTION_ID="fc757d5d-74b1-4bba-93c4-57dc82e3d464"

# Habilitar instalación automática de extensiones (opcional)
az config set extension.use_dynamic_install=yes_without_prompt

# 1. Crear Log Analytics Workspace (asegúrate de que el RG exista)
az monitor log-analytics workspace create \
  --resource-group "Desktop" \
  --workspace-name "$WORKSPACE_NAME" \
  --location "$LOCATION"

# Obtener ID del workspace
WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group "Desktop" \
  --workspace-name "$WORKSPACE_NAME" \
  --query id -o tsv)

# 2. Configurar cada VM
declare -A VMS=(
  ["BC-W03"]="Desktop"
  ["BC-W06"]="Desktop"
  ["BC-W13"]="Desktop"
)

for VM_NAME in "${!VMS[@]}"; do
  RG=${VMS[$VM_NAME]}
  echo "Configurando $VM_NAME en grupo de recursos $RG..."

  # Eliminar extensión conflictiva solo en BC-W13, si es que existe
  if [ "$VM_NAME" == "BC-W13" ]; then
    az vm extension delete \
      --resource-group "$RG" \
      --vm-name "$VM_NAME" \
      --name "IaaSDiagnostics" \
      --no-wait
  fi

  # Obtener ID completo de la VM
  VM_ID=$(az vm show \
    --resource-group "$RG" \
    --name "$VM_NAME" \
    --query id -o tsv)

  # 3. Habilitar diagnósticos de infraestructura
  #    - Quitar "VMHealth" porque da error de "Category 'VMHealth' is not supported"
  #    - Si deseas logs de VM (Guest OS logs), normalmente la categoría se llama "GuestOSLogs"
  #      pero, como también vas a usar DCR para Windows Event Logs, aquí podrías
  #      solo activar métricas. Ajusta la parte de --logs si quieres otras categorías válidas.
  az monitor diagnostic-settings create \
    --resource "$VM_ID" \
    --name "Infra-Logs" \
    --workspace "$WORKSPACE_ID" \
    --metrics '[{"category":"AllMetrics","enabled":true}]' \
    --logs '[{"category":"GuestOSLogs","enabled":true}]'  # Descomenta si quieres recoger Guest OS logs también aquí

  # 4. Crear Data Collection Rule
  #    - La CLI exige que --data-sources sea un objeto, no un array.
  #    - Observa que destinamos los "windowsEventLogs" al stream "Microsoft-Event",
  #      y en --data-flows indicamos que el stream "Microsoft-Event" va a "LogAnalyticsWorkspace".
  DCR_NAME="DCR-$VM_NAME"

  az monitor data-collection rule create \
    --resource-group "$RG" \
    --name "$DCR_NAME" \
    --location "$LOCATION" \
    --data-flows '[{"streams":["Microsoft-Event"],"destinations":["LogAnalyticsWorkspace"]}]' \
    --data-sources '{
      "windowsEventLogs": [
        {
          "name": "eventLogsDataSource",
          "streams": ["Microsoft-Event"],
          "xPathQueries": [
            "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
            "Security!*[System[(Level=1 or Level=2)]]",
            "System!*[System[(Level=1 or Level=2 or Level=3)]]"
          ]
        }
      ]
    }' \
    --destinations '{
      "logAnalytics": [
        {
          "name": "LogAnalyticsWorkspace",
          "workspaceResourceId": "'"$WORKSPACE_ID"'"
        }
      ]
    }'

  # 5. Asociar DCR a la VM
  DCR_ID=$(az monitor data-collection rule show \
    --resource-group "$RG" \
    --name "$DCR_NAME" \
    --query id -o tsv)

  az monitor data-collection rule association create \
    --name "DCRA-$VM_NAME" \
    --resource "$VM_ID" \
    --data-collection-rule-id "$DCR_ID"

done

echo "Configuración completada. Verifica los datos en:"
echo "Portal Azure > $WORKSPACE_NAME > Logs"
