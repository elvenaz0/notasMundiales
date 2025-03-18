
A continuación te presento un ejemplo de configuración completa en Terraform que crea una aplicación llamada **"APPTERRAFORM-1"** para un negocio de logística. La infraestructura incluye:

- Una VPC con subredes públicas y privadas.
- Un grupo de seguridad para controlar el acceso.
- Un grupo de Auto Scaling con un Launch Template para el **frontend** (aplicación Flask en Python) desplegado en instancias EC2 en subredes públicas.
- Un grupo de Auto Scaling con otro Launch Template para el **backend** (aplicación en Python) desplegado en subredes privadas.
- Una tabla de DynamoDB para la base de datos NoSQL de alto rendimiento.

Esta configuración utiliza variables avanzadas para parametrizar los distintos componentes.

---

```hcl
# main.tf

provider "aws" {
  region = var.aws_region
}

# VPC con subredes públicas y privadas (usando un módulo oficial)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Business    = "Logistics"
    Environment = var.environment
  }
}

# Grupo de Seguridad para la aplicación
resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group for ${var.app_name} application"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

# ===============================
# FRONTEND (Flask Python)
# ===============================
# Launch Template para el frontend
resource "aws_launch_template" "frontend_lt" {
  name_prefix   = "${var.app_name}-frontend-"
  image_id      = var.ami_id
  instance_type = var.frontend_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y python3-pip git
    pip3 install flask
    # Cloning the frontend repository
    git clone ${var.frontend_repo_url} /home/ubuntu/frontend
    cd /home/ubuntu/frontend
    # Start the Flask application (as an example, adjust as needed)
    nohup python3 app.py &
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.app_name}-frontend"
      Role = "frontend"
    }
  }
}

# Auto Scaling Group para el frontend
resource "aws_autoscaling_group" "frontend_asg" {
  name_prefix         = "${var.app_name}-frontend-asg-"
  max_size            = var.frontend_max_size
  min_size            = var.frontend_min_size
  desired_capacity    = var.frontend_desired_capacity
  vpc_zone_identifier = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.app_name}-frontend"
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "frontend"
      propagate_at_launch = true
    },
    {
      key                 = "Business"
      value               = "Logistics"
      propagate_at_launch = true
    }
  ]
}

# ===============================
# BACKEND (Python)
# ===============================
# Launch Template para el backend
resource "aws_launch_template" "backend_lt" {
  name_prefix   = "${var.app_name}-backend-"
  image_id      = var.ami_id
  instance_type = var.backend_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y python3-pip git
    pip3 install flask requests
    # Cloning the backend repository
    git clone ${var.backend_repo_url} /home/ubuntu/backend
    cd /home/ubuntu/backend
    # Start the backend application (as an example, adjust as needed)
    nohup python3 server.py &
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.app_name}-backend"
      Role = "backend"
    }
  }
}

# Auto Scaling Group para el backend
resource "aws_autoscaling_group" "backend_asg" {
  name_prefix         = "${var.app_name}-backend-asg-"
  max_size            = var.backend_max_size
  min_size            = var.backend_min_size
  desired_capacity    = var.backend_desired_capacity
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.app_name}-backend"
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "backend"
      propagate_at_launch = true
    },
    {
      key                 = "Business"
      value               = "Logistics"
      propagate_at_launch = true
    }
  ]
}

# ===============================
# BASE DE DATOS NO SQL de alto rendimiento
# (Usando DynamoDB)
# ===============================
resource "aws_dynamodb_table" "app_table" {
  name         = "${var.app_name}-nosql-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LogisticID"

  attribute {
    name = "LogisticID"
    type = "S"
  }

  tags = {
    Business = "Logistics"
    App      = var.app_name
  }
}
```

---

```hcl
# variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "logistics-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "APPTERRAFORM-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances (must be a valid Ubuntu AMI for your region)"
  type        = string
  default     = "ami-0123456789abcdef0"  # Reemplazar por un valor válido
}

variable "key_name" {
  description = "Name of the SSH key to access EC2 instances"
  type        = string
}

variable "admin_ips" {
  description = "List of admin IPs allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Ajusta según tus necesidades
}

# Configuración para el FRONTEND (Flask Python)
variable "frontend_instance_type" {
  description = "EC2 instance type for frontend"
  type        = string
  default     = "t3.medium"
}

variable "frontend_repo_url" {
  description = "Git repository URL for the Flask frontend application"
  type        = string
}

variable "frontend_min_size" {
  description = "Minimum number of frontend instances"
  type        = number
  default     = 1
}

variable "frontend_max_size" {
  description = "Maximum number of frontend instances"
  type        = number
  default     = 3
}

variable "frontend_desired_capacity" {
  description = "Desired number of frontend instances"
  type        = number
  default     = 2
}

# Configuración para el BACKEND (Python)
variable "backend_instance_type" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t3.medium"
}

variable "backend_repo_url" {
  description = "Git repository URL for the Python backend application"
  type        = string
}

variable "backend_min_size" {
  description = "Minimum number of backend instances"
  type        = number
  default     = 1
}

variable "backend_max_size" {
  description = "Maximum number of backend instances"
  type        = number
  default     = 3
}

variable "backend_desired_capacity" {
  description = "Desired number of backend instances"
  type        = number
  default     = 2
}
```

---

```hcl
# outputs.tf

output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "frontend_asg_name" {
  description = "Name of the frontend Auto Scaling Group"
  value       = aws_autoscaling_group.frontend_asg.name
}

output "backend_asg_name" {
  description = "Name of the backend Auto Scaling Group"
  value       = aws_autoscaling_group.backend_asg.name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.app_table.name
}
```

---

### Instrucciones de Despliegue

1. **Guardar los archivos:**  
    Crea los archivos `main.tf`, `variables.tf` y `outputs.tf` con el contenido mostrado.
    
2. **Inicializar Terraform:**  
    Ejecuta:
    
    ```bash
    terraform init
    ```
    
3. **Revisar el plan de ejecución:**  
    Ejecuta:
    
    ```bash
    terraform plan -out plan.tfplan
    ```
    
4. **Aplicar la configuración:**  
    Ejecuta:
    
    ```bash
    terraform apply "plan.tfplan"
    ```
    

Recuerda actualizar los valores de las variables (como el ID de la AMI, las URLs de los repositorios y la clave SSH) según los requerimientos específicos de tu negocio de logística. Con esta configuración, Terraform creará la infraestructura necesaria en AWS para hospedar tanto el frontend como el backend de tu aplicación, junto con una base de datos NoSQL de alto rendimiento.