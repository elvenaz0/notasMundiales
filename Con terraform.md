

---

## Estructura de archivos para Terraform

A continuación se muestra un **ejemplo mínimo** para desplegar la misma VM con **Terraform**. La estructura de archivos sugerida es:

```
.
├── main.tf
├── variables.tf
└── terraform.tfvars  (opcional, para sobreescribir valores)
```

### `main.tf`

```hcl
############################################
# 1) Configuración del proveedor de Azure
############################################
provider "azurerm" {
  features {}
}

############################################
# 2) Grupo de recursos
############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

############################################
# 3) Red virtual y subnet (básicas)
############################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

############################################
# 4) IP pública y NIC
############################################
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSQL"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

############################################
# 5) Creación de la VM de Windows con SQL 2019 Standard
############################################
resource "azurerm_windows_virtual_machine" "win_sql" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  # Al no usar "license_type", se asume pago por uso (PAYG) de Windows + SQL.
  # Para habilitar AHUB, se usaría: license_type = "Windows_Server", etc.
  # Pero en este caso se deja como None o se omite.

  source_image_reference {
    publisher = "microsoftsql"
    offer     = "SQL2019-WS2019"
    sku       = "SQL2019-Standard"
    version   = "latest"
  }
}

############################################
# 6) Registro del recurso "SQL Virtual Machine"
#    para habilitar las capacidades IAAS extension (opcional, pero recomendado)
############################################
resource "azurerm_sql_virtual_machine" "sql_extension" {
  name                = "${var.vm_name}-sql"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # "PAYG" para SQL Server. 
  # Si tuvieras Software Assurance, podrías usar "AHUB", etc.
  license_type   = "PAYG"

  # Habilita la administración completa (extensión IaaS Agent)
  sql_management = "Full"

  virtual_machine_id = azurerm_windows_virtual_machine.win_sql.id
}
```

### `variables.tf`

```hcl
variable "resource_group_name" {
  type        = string
  description = "Nombre del grupo de recursos donde se desplegará la VM."
}

variable "location" {
  type        = string
  description = "Región de Azure."
  default     = "eastus"
}

variable "vm_name" {
  type        = string
  description = "Nombre de la máquina virtual."
}

variable "vm_size" {
  type        = string
  description = "Tamaño (SKU) de la máquina virtual en Azure."
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador para la VM."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Contraseña del usuario administrador de la VM."
  sensitive   = true
}
```

### `terraform.tfvars` (opcional)

Aquí puedes sobreescribir las variables con los valores reales de tu despliegue, por ejemplo:

```hcl
resource_group_name = "iNBESTdbAuditoria"
location            = "Mexico Central"
vm_name             = "sql1"
vm_size             = "Standard_B2s"
admin_username      = "azureuser"
admin_password      = "TuContraseñaSegura123!"
```

### Pasos finales para desplegar con Terraform

1. **Inicializar Terraform** dentro de la carpeta que contiene los archivos:
    
    ```bash
    terraform init
    ```
    
2. **Previsualizar** el plan de creación:
    
    ```bash
    terraform plan -var-file="terraform.tfvars"
    ```
    
3. **Aplicar** los cambios para crear la infraestructura:
    
    ```bash
    terraform apply -var-file="terraform.tfvars"
    ```
    
    Confirma con `yes` cuando te pregunte.

---

## Comentarios finales

- El **enfoque con CLI** es más directo y rápido para crear la VM con SQL listo.
- El **enfoque con Terraform** te da un control **de infraestructura como código**, facilitando mantenibilidad, versionado y consistencia en despliegues repetitivos.
- Ajusta nombres, contraseñas y configuraciones de red conforme a tu entorno real.
- El licenciamiento “**pago por uso**” (PAYG) se asume por defecto al usar la imagen `MicrosoftSQL:SQL2019-WS2019:SQL2019-Standard:latest` sin indicar una licencia propia.

¡Con esto tendrás todo lo necesario para crear tu VM de SQL Server 2019 Standard en Azure con las características que necesitas!
