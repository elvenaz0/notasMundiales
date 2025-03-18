

---

Aquí tienes los pasos para crear un usuario IAM en AWS usando Terraform, siguiendo buenas prácticas de seguridad:

### 1. Crear un Usuario IAM Dedicado
```hcl
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
  tags = {
    Purpose = "Terraform deployments"
  }
}
```

### 2. Crear Política con Privilegios Mínimos
```hcl
data "aws_iam_policy_document" "terraform_policy" {
  statement {
    actions = [
      "ec2:*",
      "s3:*",
      "iam:*",
      "cloudformation:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "terraform_policy" {
  name        = "TerraformMinimumPrivileges"
  description = "Política con permisos mínimos para Terraform"
  policy      = data.aws_iam_policy_document.terraform_policy.json
}
```

### 3. Asignar Política al Usuario
```hcl
resource "aws_iam_user_policy_attachment" "terraform_attach" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}
```

### 4. Configurar MFA (Recomendado)
```hcl
# Crear dispositivo virtual MFA (la configuración final debe hacerse manualmente)
resource "aws_iam_virtual_mfa_device" "terraform_mfa" {
  virtual_mfa_device_name = "terraform-user-mfa"
  tags = {
    Purpose = "MFA for Terraform user"
  }
}
```

### 5. Crear Rol IAM para Operaciones (Mejor Práctica)
```hcl
resource "aws_iam_role" "terraform_role" {
  name = "terraform-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        AWS = aws_iam_user.terraform_user.arn
      }
    }]
  })
}

# Asignar permisos al rol
resource "aws_iam_role_policy_attachment" "terraform_role_attach" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Ajustar según necesidades
}
```

### 6. Configurar Proveedor AWS para Usar el Rol
```hcl
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = aws_iam_role.terraform_role.arn
  }
}
```

### Recomendaciones de Seguridad:
1. **Acceso Programático**:
   - Si necesitas access keys, crealas con:
     ```hcl
     resource "aws_iam_access_key" "terraform_key" {
       user = aws_iam_user.terraform_user.name
     }
     ```
     Pero **NO las almacenes en el código** - Usa secret manager o variables de entorno.

2. **Restringe Permisos**:
   - Modifica la política `terraform_policy` para incluir solo los servicios necesarios
   - Usa ARNs específicos en lugar de `"Resource": "*"`

3. **Habilita MFA Obligatorio**:
   ```hcl
   resource "aws_iam_user_policy" "mfa_policy" {
     name = "RequireMFAPolicy"
     user = aws_iam_user.terraform_user.name

     policy = jsonencode({
       Version = "2012-10-17",
       Statement = [{
         Effect   = "Deny",
         Action   = "*",
         Resource = "*",
         Condition = {
           BoolIfExists = {
             "aws:MultiFactorAuthPresent" = "false"
           }
         }
       }]
     })
   }
   ```

4. **Usa Roles en Diferentes Cuentas**:
   ```hcl
   # Para acceso cross-account
   assume_role_policy = jsonencode({
     Version = "2012-10-17",
     Statement = [{
       Action = "sts:AssumeRole",
       Effect = "Allow",
       Principal = {
         AWS = "arn:aws:iam::ACCOUNT-ID:user/terraform-user"
       }
     }]
   })
   ```

Para implementar:
1. Guarda el código en `main.tf`
2. Inicializa Terraform:
   ```bash
   terraform init
   ```
3. Revisa los cambios:
   ```bash
   terraform plan
   ```
4. Aplica la configuración:
   ```bash
   terraform apply
   ```

**Nota**: Este código debe ejecutarse con credenciales de administrador temporal, no con el usuario root.

---

A continuación tienes un **ejemplo** de estructura de archivos para organizar tus configuraciones de Terraform, separando los recursos por temas (IAM, roles, proveedor, variables, etc.). Esta organización te facilita el mantenimiento y la comprensión de tu infraestructura:

```
├── providers.tf
├── main.tf
├── variables.tf
├── iam
│   ├── user.tf
│   ├── policy.tf
│   ├── role.tf
│   └── mfa.tf
└── outputs.tf
```

A continuación se describe qué iría en cada archivo:

1. **providers.tf**
    
    - Aquí defines la configuración del **provider "aws"** con la región, asunción de rol (si corresponde), etc.
    - Por ejemplo, si vas a usar el rol que creas para Terraform:
        
        ```hcl
        provider "aws" {
          region = "us-east-1"
        
          assume_role {
            role_arn = aws_iam_role.terraform_role.arn
          }
        }
        ```
        
2. **main.tf**
    
    - Puede quedar vacío (o con un `terraform` block para configuraciones globales) si prefieres mantener todo tu IAM separado.
    - O puedes colocar en `main.tf` la mayor parte de la infraestructura (EC2, S3, etc.) y solo delegar la parte de IAM a la carpeta `iam`.
    - Ejemplo de bloque global:
        
        ```hcl
        terraform {
          required_version = ">= 1.0.0"
        
          required_providers {
            aws = {
              source  = "hashicorp/aws"
              version = "~> 4.0"
            }
          }
        }
        ```
        
3. **variables.tf**
    
    - Define cualquier variable que necesites reutilizar. Por ejemplo, región, nombres de usuarios, ARNs, etc.
    
    ```hcl
    variable "aws_region" {
      type    = string
      default = "us-east-1"
    }
    
    variable "admin_policy_arn" {
      type    = string
      default = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
    ```
    
4. **iam/user.tf**
    
    - Define la creación de tu usuario IAM dedicado a Terraform:
        
        ```hcl
        resource "aws_iam_user" "terraform_user" {
          name = "terraform-user"
          tags = {
            Purpose = "Terraform deployments"
          }
        }
        
        # Opcional: Access Keys (no recomendado en entornos de producción)
        resource "aws_iam_access_key" "terraform_user_key" {
          user = aws_iam_user.terraform_user.name
        }
        ```
        
5. **iam/policy.tf**
    
    - Contiene la definición de la política de privilegios mínimos y su adjuntación al usuario:
        
        ```hcl
        data "aws_iam_policy_document" "terraform_policy" {
          statement {
            actions = [
              "ec2:*",
              "s3:*",
              "iam:*",
              "cloudformation:*"
            ]
            resources = ["*"]
            effect    = "Allow"
          }
        }
        
        resource "aws_iam_policy" "terraform_policy" {
          name        = "TerraformMinimumPrivileges"
          description = "Política con permisos mínimos para Terraform"
          policy      = data.aws_iam_policy_document.terraform_policy.json
        }
        
        resource "aws_iam_user_policy_attachment" "terraform_attach" {
          user       = aws_iam_user.terraform_user.name
          policy_arn = aws_iam_policy.terraform_policy.arn
        }
        ```
        
6. **iam/role.tf**
    
    - Define el rol IAM que asume tu usuario (o un rol cross-account):
        
        ```hcl
        resource "aws_iam_role" "terraform_role" {
          name = "terraform-execution-role"
        
          assume_role_policy = jsonencode({
            Version = "2012-10-17",
            Statement = [{
              Action = "sts:AssumeRole",
              Effect = "Allow",
              Principal = {
                AWS = aws_iam_user.terraform_user.arn
              }
            }]
          })
        }
        
        resource "aws_iam_role_policy_attachment" "terraform_role_attach" {
          role       = aws_iam_role.terraform_role.name
          policy_arn = var.admin_policy_arn
        }
        ```
        
7. **iam/mfa.tf**
    
    - Incluye la configuración del dispositivo MFA y la política para exigir MFA:
        
        ```hcl
        resource "aws_iam_virtual_mfa_device" "terraform_mfa" {
          virtual_mfa_device_name = "terraform-user-mfa"
          tags = {
            Purpose = "MFA for Terraform user"
          }
        }
        
        resource "aws_iam_user_policy" "mfa_policy" {
          name = "RequireMFAPolicy"
          user = aws_iam_user.terraform_user.name
        
          policy = jsonencode({
            Version = "2012-10-17",
            Statement = [{
              Effect   = "Deny",
              Action   = "*",
              Resource = "*",
              Condition = {
                BoolIfExists = {
                  "aws:MultiFactorAuthPresent" = "false"
                }
              }
            }]
          })
        }
        ```
        
8. **outputs.tf** (opcional)
    
    - Define outputs que quieras hacer visibles tras el `terraform apply`. Por ejemplo, la ARN del rol, la access key del usuario, etc.
    
    ```hcl
    output "terraform_user_arn" {
      value = aws_iam_user.terraform_user.arn
    }
    
    output "terraform_role_arn" {
      value = aws_iam_role.terraform_role.arn
    }
    ```
    

---

## ¿Cómo usar esta estructura?

1. **Inicializa**
    
    ```bash
    terraform init
    ```
    
2. **Previsualiza cambios**
    
    ```bash
    terraform plan
    ```
    
3. **Aplica la configuración**
    
    ```bash
    terraform apply
    ```
    
4. Ajusta permisos, variables y roles según tu flujo de trabajo y servicios que vayas a gestionar.

Esta división en archivos te permite crecer y mantener el código más ordenado, especialmente cuando incrementes la complejidad de tu infraestructura.

---

A continuación tienes un ejemplo de script **bash** (`.sh`) que crea la estructura de carpetas y archivos solicitados. Puedes copiarlo en un archivo (por ejemplo `init_terraform.sh`), darle permisos de ejecución con `chmod +x init_terraform.sh` y luego ejecutarlo:

```bash
#!/usr/bin/env bash
# init_terraform.sh
# Script para crear estructura de archivos y carpetas para Terraform

# Crear carpeta principal 'iam'
mkdir -p iam

# Crear archivos en la raíz
touch providers.tf
touch main.tf
touch variables.tf
touch outputs.tf

# Crear archivos dentro de la carpeta 'iam'
touch iam/user.tf
touch iam/policy.tf
touch iam/role.tf
touch iam/mfa.tf

echo "Estructura de archivos creada exitosamente."
```

**Uso**:

1. Asegúrate de que el archivo `.sh` tenga permisos de ejecución:
    
    ```bash
    chmod +x init_terraform.sh
    ```
    
2. Ejecuta el script:
    
    ```bash
    ./init_terraform.sh
    ```