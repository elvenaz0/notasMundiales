

## codigo original

```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="Mexico Central"
VM_NAME="sql1"
VM_SIZE="Standard_B2s"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# 1) Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 2) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:SQL2019-WS2019:SQL2019-Standard:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --license-type None  # Se asume pago por uso tanto de Windows como de SQL.
                       # (No traes licencias propias - BYOL).
# Nota:
#  --license-type None => Se cobrará SQL y SO bajo Pago por Uso (PAYG). 
#  Si tuvieses Software Assurance y quisieras aplicar AHUB (Azure Hybrid Use Benefit),
#  tendrías que ajustar --license-type a "Windows_Server" o "SQL_Server_HA" según corresponda.

# 4) (Opcional) Abrir puertos específicos si requieres conectarte a SQL desde fuera
#    Ejemplo para RDP (puerto 3389) y SQL Server (puerto 1433):
az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port "3389" --priority 1001

az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port "1433" --priority 1002

echo "Máquina Virtual '$VM_NAME' con SQL Server 2019 Standard desplegada exitosamente."

```


---
# iteraciones

## 5 como iaas v2 directo a sql

```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="mexicocentral"
VM_NAME="sql2withIaasV2"
SQL_RESOURCE_NAME="sql2withIaasV2-sql"
VM_SIZE="Standard_B2s"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# 1) Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 2) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# 3) Crear la VM de Windows con SQL 2019 Standard
#    (sin Trusted Launch, ni plan; se asume pago por uso de Windows y SQL).
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:sql2019-ws2019:standard:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --license-type None

# 4) (Opcional) Abrir puertos RDP (3389) y SQL (1433)
az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port 3389 --priority 1001

az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port 1433 --priority 1002

# 5) Obtener el ID (la ruta ARM) de la VM recién creada.
VM_ID=$(az vm show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --query "id" -o tsv)

# 6) Crear el recurso "SQL Virtual Machine" (extensión IaaS) usando --resource-id
az sql vm create \
  --name "$SQL_RESOURCE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --license-type PAYG \
  --sql-mgmt-type Full \
  --resource-id "$VM_ID"

echo "VM '$VM_NAME' creada y registrada como SQL VM con nombre '$SQL_RESOURCE_NAME'."
echo "Ahora debería aparecer en la sección 'Máquinas virtuales de SQL' del Portal."

```

## 4 como iaas

```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="mexicocentral"
VM_NAME="sql2withIaas"
SQL_RESOURCE_NAME="sql2withIaas-sql"
VM_SIZE="Standard_B2s"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# 1) Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 2) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# 3) Crear la VM de Windows con SQL 2019 Standard (sin plan / sin Trusted Launch)
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:sql2019-ws2019:standard:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --license-type None

# 4) (Opcional) Abrir puertos RDP (3389) y SQL (1433)
az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port 3389 --priority 1001

az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port 1433 --priority 1002

# 5) Obtener el ID de la VM para registrar la IaaS extension
VM_ID=$(az vm show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --query "id" -o tsv)

# 6) Crear el recurso "SQL Virtual Machine" (IaaS extension)
az sql vm create \
  --name "$SQL_RESOURCE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --license-type PAYG \
  --sql-mgmt-type Full \
  --virtual-machine-resource-id "$VM_ID"

echo "VM '$VM_NAME' creada y registrada como 'SQL Virtual Machine' con nombre '$SQL_RESOURCE_NAME'."
echo "¡Ahora debería aparecer en la sección 'Máquinas virtuales de SQL' del Portal!"

```


## 3

```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="mexicocentral"
VM_NAME="sql2ConTrustedLaunch"
VM_SIZE="Standard_D4s_v5"     # Ejemplo: soporta Gen2 / Trusted Launch
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# 1) Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 2) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# 3) Crear la VM con la variante Gen2 y Trusted Launch
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:sql2019-ws2019:standard-gen2:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --security-type TrustedLaunch \
  --enable-secure-boot true \
  --enable-vtpm true \
  --license-type None

# 4) Abrir puertos para RDP y SQL (opcional)
az vm open-port --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --port 3389 --priority 1001
az vm open-port --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --port 1433 --priority 1002

echo "Máquina Virtual '$VM_NAME' con SQL Server 2019 Standard (Gen2, Trusted Launch) desplegada exitosamente."

```


## 2

```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="mexicocentral"
VM_NAME="sql1"
VM_SIZE="Standard_B2s"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 1) Aceptar Términos del Marketplace:
#    Fíjate que ahora plan sea "standard" y no "SQL2019-Standard"
az vm image terms accept \
  --publisher "MicrosoftSQLServer" \
  --offer "sql2019-ws2019" \
  --plan "standard"

# 2) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# 3) Crear la VM con la imagen de SQL 2019 Standard
#    usando la SKU "standard"
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:sql2019-ws2019:standard:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --plan-publisher "MicrosoftSQLServer" \
  --plan-product "sql2019-ws2019" \
  --plan-name "standard" \
  --license-type None

# 4) Abrir puertos para RDP y SQL
az vm open-port --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --port "3389" --priority 1001
az vm open-port --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --port "1433" --priority 1002

echo "Máquina Virtual '$VM_NAME' con SQL Server 2019 Standard desplegada exitosamente."

```


## 1
```
#!/usr/bin/env bash

# Variables de entorno (ajústalas según tus necesidades)
SUBSCRIPTION_NAME="Big Wave Data 2025"
RESOURCE_GROUP="iNBESTdbAuditoria"
LOCATION="Mexico Central"
VM_NAME="sql1"
VM_SIZE="Standard_B2s"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="TuContraseñaSegura123!"

# 1) Seleccionar la suscripción
az account set --subscription "$SUBSCRIPTION_NAME"

# 2) Aceptar Términos del Marketplace para la imagen de SQL:
#    Esto asegura que no aparezcan errores/advertencias al crear la VM.
az vm image terms accept \
  --publisher "MicrosoftSQLServer" \
  --offer "SQL2019-WS2019" \
  --plan "SQL2019-Standard"

# 3) Crear (o validar) el grupo de recursos
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# 4) Crear la VM con la imagen de SQL Server 2019 Standard
#    - Se especifica el plan (publisher, product y name) para que
#      la CLI no muestre advertencias sobre el plan.
#    - --license-type None => Pago por uso de Windows + SQL (PAYG).
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --image "MicrosoftSQLServer:SQL2019-WS2019:SQL2019-Standard:latest" \
  --size "$VM_SIZE" \
  --location "$LOCATION" \
  --admin-username "$ADMIN_USER" \
  --admin-password "$ADMIN_PASSWORD" \
  --plan-publisher "MicrosoftSQLServer" \
  --plan-product "SQL2019-WS2019" \
  --plan-name "SQL2019-Standard" \
  --license-type None

# 5) (Opcional) Abrir puertos para RDP (3389) y SQL Server (1433)
az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port "3389" --priority 1001

az vm open-port \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --port "1433" --priority 1002

echo "Máquina Virtual '$VM_NAME' con SQL Server 2019 Standard desplegada exitosamente."

```