#!/bin/bash

# Configuración común
WORKSPACE_NAME="VM-Logs-Workspace"
LOCATION="westus"
SUBSCRIPTION_ID="fc757d5d-74b1-4bba-93c4-57dc82e3d464"

# Habilitar instalación automática de extensiones
az config set extension.use_dynamic_install=yes_without_prompt

# 1. Crear Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group "Desktop" \
  --workspace-name $WORKSPACE_NAME \
  --location $LOCATION

# Obtener ID del workspace
WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group "Desktop" \
  --workspace-name $WORKSPACE_NAME \
  --query id -o tsv)

# 2. Configurar cada VM
declare -A VMS=(
  ["BC-W03"]="DESKTOP"
  ["BC-W06"]="Desktop"
  ["BC-W13"]="Desktop"
)

for VM_NAME in "${!VMS[@]}"; do
  RG=${VMS[$VM_NAME]}
  echo "Configurando $VM_NAME en grupo de recursos $RG..."

  # Eliminar extensión conflictiva en BC-W13
  if [ "$VM_NAME" == "BC-W13" ]; then
    az vm extension delete \
      --resource-group $RG \
      --vm-name $VM_NAME \
      --name "IaaSDiagnostics" \
      --no-wait
  fi

  # Habilitar diagnósticos
  VM_ID=$(az vm show \
    --resource-group $RG \
    --name $VM_NAME \
    --query id -o tsv)

  az monitor diagnostic-settings create \
    --resource $VM_ID \
    --name "Infra-Logs" \
    --workspace $WORKSPACE_ID \
    --logs '[{"category":"BootDiagnostics","enabled":true}]' \
    --metrics '[{"category":"AllMetrics","enabled":true}]'

  # Crear Data Collection Rule (CORREGIDO)
  DCR_NAME="DCR-$VM_NAME"
  az monitor data-collection rule create \
    --resource-group $RG \
    --name $DCR_NAME \
    --location $LOCATION \
    --data-flows '[{"destinations":["LogAnalyticsWorkspace"],"streams":["Microsoft-Event"]}]' \
    --data-sources '[
      {
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
      }
    ]' \
    --destinations "{\"logAnalytics\": [{\"workspaceResourceId\": \"$WORKSPACE_ID\", \"name\": \"LogAnalyticsWorkspace\"}]}"

  # Asociar DCR a la VM
  DCR_ID=$(az monitor data-collection rule show \
    --resource-group $RG \
    --name $DCR_NAME \
    --query id -o tsv)

  az monitor data-collection rule association create \
    --name "DCRA-$VM_NAME" \
    --resource $VM_ID \
    --data-collection-rule-id $DCR_ID
done

echo "Configuración completada. Verifica los datos en:"
echo "Portal Azure > $WORKSPACE_NAME > Logs"