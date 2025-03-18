A continuación verás ejemplos y conceptos básicos para **crear, administrar, monitorear y eliminar** distintos servicios de Azure usando la **Azure CLI**. También se incluyen referencias a la documentación oficial. Estos comandos se ejecutan principalmente en una **shell** con la CLI instalada, o en el **Azure Cloud Shell** del portal.

> **Nota**: Antes de cualquier operación, inicia sesión con
> 
> ```bash
> az login
> ```
> 
> y, si manejas múltiples suscripciones, selecciona la correcta:
> 
> ```bash
> az account set --subscription <NOMBRE_O_ID_DE_SUSCRIPCION>
> ```

---

# 1. Máquinas Virtuales (Azure VMs)

## 1.1 Crear una VM

```bash
az vm create \
  --resource-group MyResourceGroup \
  --name MyVM \
  --image UbuntuLTS \
  --admin-username azureuser \
  --authentication-type ssh \
  --ssh-key-values ~/.ssh/id_rsa.pub
```

- **Descripción**: Crea una VM Linux en el grupo de recursos `MyResourceGroup`, con una clave SSH.
- **Documentación**:[[ [Documentación de az vm create](https://learn.microsoft.com/cli/azure/vm?view=azure-cli-latest#az-vm-create)]]

## 1.2 Conectarse a la VM

- **SSH** (Linux):
    
    ```bash
    ssh azureuser@<IP-PUBLICA>
    ```
    
    (obtén la IP con `az vm show --show-details --name MyVM --resource-group MyResourceGroup --query publicIps -o tsv`)
    
- **RDP** (Windows):  
    Descarga el archivo RDP o conéctate desde un cliente RDP usando la IP pública.
    

## 1.3 Cambiar tamaño (resize)

```bash
az vm resize \
  --resource-group MyResourceGroup \
  --name MyVM \
  --size Standard_D2s_v3
```

- **Descripción**: Cambia el tamaño de la VM a D2s_v3.
- **Documentación**: [Cambiar tamaño de VM](https://learn.microsoft.com/azure/virtual-machines/resize-vm)

## 1.4 Monitorear métricas de VM

```bash
az monitor metrics list \
  --resource "/subscriptions/<SUB_ID>/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/MyVM" \
  --metric "Percentage CPU" \
  --interval PT1H
```

- **Descripción**: Muestra la métrica “Percentage CPU” de la VM en el último intervalo de 1 hora.
- **Documentación**: [az monitor metrics list](https://learn.microsoft.com/cli/azure/monitor/metrics?view=azure-cli-latest#az-monitor-metrics-list)

## 1.5 Eliminar la VM

```bash
az vm delete \
  --resource-group MyResourceGroup \
  --name MyVM \
  --yes
```

- **Descripción**: Elimina la VM (puedes agregar `--no-wait` para no esperar confirmación).
- **Documentación**: [az vm delete](https://learn.microsoft.com/cli/azure/vm?view=azure-cli-latest#az-vm-delete)

---

# 2. Azure Functions

## 2.1 Crear Function App

```bash
# 1) Crear un Plan de Consumo (opcional si no existe)
az functionapp plan create \
  --name MyPlan \
  --resource-group MyResourceGroup \
  --location eastus \
  --is-linux \
  --number-of-workers 1 \
  --sku EP1

# 2) Crear la Function App
az functionapp create \
  --name MyFunctionApp \
  --storage-account mystorageaccount \
  --consumption-plan-location eastus \
  --resource-group MyResourceGroup \
  --runtime python
```

- **Descripción**: Crea una Function App con runtime de Python en un plan de consumo.
- **Documentación**: [Azure Functions CLI reference](https://learn.microsoft.com/azure/azure-functions/functions-reference?tabs=bash)

## 2.2 Desplegar Funciones

- Usa herramientas como **Azure Functions Core Tools** o GitHub Actions para subir el código.
- [Tutorial oficial para despliegues](https://learn.microsoft.com/azure/azure-functions/functions-develop-vs-code?tabs=csharp)

## 2.3 Monitorear Function App

```bash
az monitor metrics list \
  --resource "/subscriptions/<SUB_ID>/resourceGroups/MyResourceGroup/providers/Microsoft.Web/sites/MyFunctionApp" \
  --metric "Requests" \
  --interval PT1H
```

- **Descripción**: Consulta cuántas ejecuciones (“Requests”) ha tenido la Function en la última hora.

## 2.4 Eliminar Function App

```bash
az functionapp delete \
  --resource-group MyResourceGroup \
  --name MyFunctionApp
```

- **Documentación**: [az functionapp delete](https://learn.microsoft.com/cli/azure/functionapp?view=azure-cli-latest#az-functionapp-delete)

---

# 3. Contenedores (Azure Container Instances / AKS)

## 3.1 Azure Container Instances (ACI)

### 3.1.1 Crear un contenedor en ACI

```bash
az container create \
  --resource-group MyResourceGroup \
  --name MyContainer \
  --image mcr.microsoft.com/azuredocs/aci-helloworld \
  --ports 80 \
  --memory 1.5 \
  --cpu 1
```

- **Descripción**: Despliega un contenedor de ejemplo con 1 CPU y 1.5 GB de RAM.
- **Documentación**: [az container create](https://learn.microsoft.com/cli/azure/container?view=azure-cli-latest#az-container-create)

### 3.1.2 Ver estado e IP pública

```bash
az container show \
  --name MyContainer \
  --resource-group MyResourceGroup \
  --query "ipAddress.ip" -o tsv
```

### 3.1.3 Eliminar contenedor

```bash
az container delete \
  --name MyContainer \
  --resource-group MyResourceGroup \
  --yes
```

## 3.2 Azure Kubernetes Service (AKS)

### 3.2.1 Crear un clúster AKS básico

```bash
az aks create \
  --resource-group MyResourceGroup \
  --name MyAKSCluster \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

- **Descripción**: Crea un clúster AKS con 2 nodos y habilita el addon de monitoreo (OMS/Container Insights).
- **Documentación**: [az aks create](https://learn.microsoft.com/cli/azure/aks?view=azure-cli-latest#az-aks-create)

### 3.2.2 Conectarse al clúster

```bash
az aks get-credentials \
  --resource-group MyResourceGroup \
  --name MyAKSCluster
```

- **Descripción**: Descarga credenciales y las agrega a tu archivo `~/.kube/config`. Luego podrás usar `kubectl` para interactuar con el clúster.

### 3.2.3 Desplegar un contenedor

```bash
kubectl create deployment myapp --image=nginx
```

- **Descripción**: Crea un despliegue con la imagen `nginx`.

### 3.2.4 Escalar, monitorear y eliminar

- **Escalar**: `kubectl scale deployment myapp --replicas=5`
- **Monitorear**: `kubectl get pods`, `kubectl describe pod <NAME>`
- **Eliminar**: `az aks delete --resource-group MyResourceGroup --name MyAKSCluster`

---

# 4. Redes (VNet, VPN Gateway, ExpressRoute)

## 4.1 Virtual Network

### 4.1.1 Crear una VNet con subred

```bash
az network vnet create \
  --name MyVNet \
  --resource-group MyResourceGroup \
  --address-prefix 10.0.0.0/16 \
  --subnet-name MySubnet \
  --subnet-prefix 10.0.1.0/24
```

- **Documentación**: [az network vnet create](https://learn.microsoft.com/cli/azure/network/vnet?view=azure-cli-latest#az-network-vnet-create)

### 4.1.2 Mostrar la VNet

```bash
az network vnet show \
  --resource-group MyResourceGroup \
  --name MyVNet
```

### 4.1.3 Eliminar VNet

```bash
az network vnet delete \
  --resource-group MyResourceGroup \
  --name MyVNet
```

## 4.2 VPN Gateway

### 4.2.1 Creación básica de VPN Gateway

1. Crea una subnet “GatewaySubnet” en tu VNet:
    
    ```bash
    az network vnet subnet create \
      --resource-group MyResourceGroup \
      --vnet-name MyVNet \
      --name GatewaySubnet \
      --address-prefix 10.0.2.0/24
    ```
    
2. Crea IP pública para la gateway:
    
    ```bash
    az network public-ip create \
      --resource-group MyResourceGroup \
      --name MyVPNPublicIP \
      --allocation-method Dynamic
    ```
    
3. Crea el VPN Gateway:
    
    ```bash
    az network vnet-gateway create \
      --name MyVpnGateway \
      --resource-group MyResourceGroup \
      --vnet MyVNet \
      --gateway-type Vpn \
      --sku VpnGw1 \
      --public-ip-addresses MyVPNPublicIP
    ```
    

- **Documentación**: [Tutorial VPN Gateway](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-cli)

### 4.2.2 Eliminar VPN Gateway

```bash
az network vnet-gateway delete \
  --resource-group MyResourceGroup \
  --name MyVpnGateway
```

## 4.3 ExpressRoute

- Se requieren pasos adicionales con el proveedor de conectividad. El flujo general es:
    1. Crear un **circuito ExpressRoute** (`az network express-route create`).
    2. Aprovisionar el circuito con el proveedor.
    3. Vincular a la VNet (`az network vnet-gateway create --gateway-type ExpressRoute`).
- **Documentación**: [ExpressRoute CLI](https://learn.microsoft.com/azure/expressroute/expressroute-howto-circuit-cli)

---

# 5. Almacenamiento (Blob, Files, Redundancia, AzCopy)

## 5.1 Crear cuenta de almacenamiento

```bash
az storage account create \
  --resource-group MyResourceGroup \
  --name mystorageaccount \
  --location eastus \
  --sku Standard_LRS
```

- **Documentación**: [az storage account create](https://learn.microsoft.com/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-create)

## 5.2 Crear contenedor Blob

```bash
az storage container create \
  --name myblobcontainer \
  --account-name mystorageaccount \
  --public-access off
```

- **Documentación**: [az storage container create](https://learn.microsoft.com/cli/azure/storage/container?view=azure-cli-latest#az-storage-container-create)

## 5.3 Subir archivos con AzCopy

```bash
azcopy copy "/path/local/*" "https://mystorageaccount.blob.core.windows.net/myblobcontainer<SAS_TOKEN>" --recursive=true
```

- **Descripción**: Copia archivos de la carpeta local al contenedor Blob, usando una **SAS (Shared Access Signature)** para autenticación.
- **Documentación**: [AzCopy overview](https://learn.microsoft.com/azure/storage/common/storage-use-azcopy-v10)

## 5.4 Crear Azure File Share

```bash
az storage share create \
  --name myfileshare \
  --account-name mystorageaccount
```

- **Documentación**: [Crear Azure Files share](https://learn.microsoft.com/cli/azure/storage/share?view=azure-cli-latest#az-storage-share-create)

## 5.5 Eliminar cuenta de almacenamiento

```bash
az storage account delete \
  --resource-group MyResourceGroup \
  --name mystorageaccount
```

---

# 6. Seguridad e Identidad (Azure AD / Entra ID, RBAC, Zero Trust)

> **Importante**: Muchos comandos de Azure AD requieren instalar la [extensión Azure CLI para Microsoft Graph (az ad)](https://learn.microsoft.com/cli/azure/azure-cli-extensions-list?view=azure-cli-latest), o usar `AzureAD` PowerShell o Microsoft Graph PowerShell. Algunos comandos de Azure AD están siendo migrados al nuevo endpoint de Microsoft Entra.

## 6.1 Crear usuario en Azure AD (Entra ID)

```bash
az ad user create \
  --display-name "Juan Pérez" \
  --user-principal-name juan.perez@midominio.onmicrosoft.com \
  --password "Contraseña123!"
```

- **Documentación**: [az ad user create](https://learn.microsoft.com/cli/azure/ad/user?view=azure-cli-latest#az-ad-user-create)

## 6.2 Asignar roles RBAC

```bash
az role assignment create \
  --assignee juan.perez@midominio.onmicrosoft.com \
  --role "Virtual Machine Contributor" \
  --scope "/subscriptions/<SUB_ID>/resourceGroups/MyResourceGroup"
```

- **Descripción**: Da a ese usuario permisos de “Contributor” de VMs en el grupo de recursos especificado.
- **Documentación**: [az role assignment create](https://learn.microsoft.com/cli/azure/role/assignment?view=azure-cli-latest#az-role-assignment-create)

## 6.3 Modelo de Confianza Cero

- **Azure CLI** en sí no habilita “Zero Trust” con un solo comando, pues es un **modelo** que involucra:
    - **MFA** (requiere configuración en Azure AD).
    - **Condicional Access** (Planes Premium de Azure AD).
    - **Revisiones de acceso**, segmentación de red (NSGs, firewall).
- **Documentación**:
    - [Conceptos de Zero Trust en Azure](https://learn.microsoft.com/security/zero-trust)
    - [Configuración de MFA](https://learn.microsoft.com/azure/active-directory/authentication/tutorial-enable-azure-mfa)

---

# 7. Eliminación (Limpieza de recursos)

Para **evitar costos** innecesarios, puedes eliminar recursos o grupos de recursos completos:

```bash
# Eliminar un grupo de recursos entero (y todo lo que contiene)
az group delete \
  --name MyResourceGroup \
  --yes
```

- **Documentación**: [az group delete](https://learn.microsoft.com/cli/azure/group?view=azure-cli-latest#az-group-delete)

---

# Referencias Generales

4. **Documentación de Azure CLI**
    
    - [CLI Reference - Índice principal](https://learn.microsoft.com/cli/azure/reference-index?view=azure-cli-latest)
5. **Azure CLI Examples**
    
    - Cada comando en la doc oficial incluye secciones _Examples_ para ver casos prácticos.
6. **Azure Quickstart Templates**
    
    - [Repositorio en GitHub](https://github.com/Azure/azure-quickstart-templates) con plantillas ARM/Bicep que ejemplifican despliegues automatizados (puedes combinarlas con la CLI).
7. **Recursos para AzCopy**
    
    - [AzCopy V10 Documentation](https://learn.microsoft.com/azure/storage/common/storage-use-azcopy-v10)
8. **Azure Monitor / RBAC**
    
    - [Azure Monitor CLI Docs](https://learn.microsoft.com/cli/azure/monitor?view=azure-cli-latest)
    - [RBAC CLI Docs](https://learn.microsoft.com/cli/azure/role?view=azure-cli-latest)

---

## Resumen

Con la **Azure CLI**, puedes gestionar la mayoría de los servicios de Azure (crear, configurar, monitorear y eliminar) de forma automatizada y repetible. Los ejemplos anteriores cubren los comandos básicos para:

- **Máquinas Virtuales** (VMs): Creación, conexión, cambio de tamaño, monitoreo, eliminación.
- **Azure Functions**: Creación de Function App, despliegue de código, monitoreo y eliminación.
- **Contenedores** (ACI / AKS): Creación de instancias de contenedor, cluster Kubernetes, despliegues y escalado.
- **Redes** (VNet, VPN Gateway, ExpressRoute): Definir redes virtuales, configurar pasarelas VPN y circuitos dedicados.
- **Almacenamiento** (Blob, Files, Redundancia, AzCopy): Crear cuentas de almacenamiento, contenedores, transferir datos y administrar redundancia.
- **Seguridad e Identidad** (Azure AD / RBAC / Zero Trust): Crear usuarios, asignar roles, y utilizar principios de Confianza Cero.

Para más detalles, consulta la documentación oficial en [Microsoft Learn](https://learn.microsoft.com/azure/?product=featured).