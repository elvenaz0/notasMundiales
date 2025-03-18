
Below are several advanced approaches to configuring Terraform variables, complete with practical code examples. The goal is to demonstrate how variables can be structured and used for more sophisticated use cases—ranging from conditional logic and complex data types to module reusability.

---

## 1. Defining Complex Data Types

Terraform supports a variety of variable types (string, list, map, bool, number, etc.). It can also enforce complex type constraints:

```hcl
variable "app_config" {
  type = object({
    environment     = string
    instance_type   = string
    instance_count  = number
    tags            = map(string)
    feature_flags   = list(string)
  })
  default = {
    environment    = "development"
    instance_type  = "t3.micro"
    instance_count = 2
    tags = {
      "Owner"  = "DevOps"
      "Module" = "Frontend"
    }
    feature_flags = ["featureX", "featureY"]
  }
}
```

Here:
- **object()** enforces a well-defined structure.
- Users must provide matching attribute names and types. This ensures consistent usage across environments.

### Usage in Terraform Resources
```hcl
resource "aws_instance" "web" {
  count         = var.app_config.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.app_config.instance_type

  tags = merge(
    var.app_config.tags,
    { "Name" = "web-instance-${count.index}" }
  )
}
```

---

## 2. Using Validation Blocks for Variables

Terraform allows validation rules, so you can fail fast if a variable is out of the expected range or format:

```hcl
variable "region" {
  type    = string
  default = "us-east-1"

  validation {
    condition     = can(regex("^us-", var.region))
    error_message = "The region must be in the 'us-' prefix (e.g., us-east-1, us-west-2)."
  }
}

variable "instance_count" {
  type    = number
  default = 1

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

If `region` or `instance_count` do not satisfy these conditions, Terraform will halt the run and display your custom error.

---

## 3. Conditional Logic and Default Values

You can combine variables with Terraform’s conditional expressions to derive dynamic configurations:

```hcl
variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "desired_count" {
  type    = number
  default = 2
}

resource "aws_autoscaling_group" "example" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "example-asg"
  max_size            = var.enable_autoscaling ? 10 : var.desired_count
  min_size            = var.enable_autoscaling ? 1  : var.desired_count
  desired_capacity    = var.desired_count
  ...
}
```

**Key Points**:
- When `enable_autoscaling` is false, the `aws_autoscaling_group` resource is not created at all (`count = 0`).
- The `max_size` and `min_size` also adapt based on `enable_autoscaling`.

---

## 4. Hierarchical / Nested Variables with Modules

Variables become especially powerful in modules. You can define module inputs that map to other module variables or resources.

### Root Module Variables
```hcl
variable "database_config" {
  type = object({
    name            = string
    engine          = string
    instance_class  = string
    allocated_storage = number
  })
}
```

### Module Definition
```hcl
module "rds" {
  source = "./modules/rds"

  db_name           = var.database_config.name
  db_engine         = var.database_config.engine
  db_instance_class = var.database_config.instance_class
  db_storage        = var.database_config.allocated_storage
}
```

### Sub-Module Variables
In the `./modules/rds` module, define inputs:
```hcl
variable "db_name" {
  type = string
}
variable "db_engine" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_storage" {
  type = number
}

resource "aws_db_instance" "main" {
  identifier               = var.db_name
  engine                   = var.db_engine
  instance_class           = var.db_instance_class
  allocated_storage        = var.db_storage
  ...
}
```

This nesting pattern helps keep configurations DRY (Don’t Repeat Yourself) and scalable.

---

## 5. Complex Defaults with `local` Values

Sometimes you want to compose default values conditionally from multiple variables. Using `locals` can help maintain readability:

```hcl
variable "app_version" {
  type    = string
  default = "v1.0"
}

variable "feature_switches" {
  type = object({
    featureA = bool
    featureB = bool
  })
  default = {
    featureA = true
    featureB = false
  }
}

locals {
  # Compose a string from variables
  image_tag = "${var.app_version}-${replace(timestamp(), "[: T-]", "")}"

  # Conditionally set a default
  featureA_value = var.feature_switches.featureA ? "enabled" : "disabled"
  featureB_value = var.feature_switches.featureB ? "enabled" : "disabled"
}

resource "aws_ecs_task_definition" "app" {
  container_definitions = jsonencode([
    {
      name  = "app-container"
      image = "myrepo/myapp:${local.image_tag}"
      environment = [
        { "name" = "FEATURE_A", "value" = local.featureA_value },
        { "name" = "FEATURE_B", "value" = local.featureB_value },
      ]
    }
  ])
}
```

By combining variables and locals:
- You build a more descriptive default (an image tag with a timestamp).
- You conditionally derive environment variables inside a container.

---

## 6. Using Maps and Loops for Resource Creation

When you have many similar resources, you can store their definitions in a variable map and use `for_each` to loop over them:

```hcl
variable "sg_rules" {
  type = map(object({
    port     = number
    protocol = string
    cidr     = string
  }))
  default = {
    ssh = {
      port     = 22
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    }
    http = {
      port     = 80
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    }
  }
}

resource "aws_security_group_rule" "allow_inbound" {
  for_each = var.sg_rules

  type        = "ingress"
  from_port   = each.value.port
  to_port     = each.value.port
  protocol    = each.value.protocol
  cidr_blocks = [each.value.cidr]
  security_group_id = aws_security_group.main.id
}
```

In this example:
- You define multiple security group rules via a single map variable.
- The `for_each` expression iterates over each rule and creates a security group rule resource.

---

## 7. Variable Files for Environment Overrides

Terraform supports loading variable definitions from external files (e.g., `dev.tfvars`, `prod.tfvars`), making it easy to customize configurations per environment:

**`dev.tfvars`**:
```hcl
app_config = {
  environment    = "development"
  instance_type  = "t3.micro"
  instance_count = 2
  tags = {
    "Owner"  = "DevOps"
    "Module" = "Frontend"
  }
  feature_flags = ["featureX", "featureY"]
}
```

**`prod.tfvars`**:
```hcl
app_config = {
  environment    = "production"
  instance_type  = "m5.large"
  instance_count = 5
  tags = {
    "Owner"  = "Ops"
    "Module" = "Frontend"
  }
  feature_flags = ["featureX", "featureY", "featureZ"]
}
```

When you run Terraform:
```bash
terraform apply -var-file="dev.tfvars"
```
or
```bash
terraform apply -var-file="prod.tfvars"
```
You can selectively override defaults for each environment.

---

## 8. Polymorphic Variables Using `any`

If you need a variable to accept multiple potential types (for example, either a string or list of strings), Terraform provides a special `any` type:

```hcl
variable "paths" {
  type = any
}

locals {
  paths_list = (
    type(var.paths) == list(string)
    ? var.paths
    : [var.paths] # Coerce a single string to a list
  )
}

# Example usage
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = join(" ", local.paths_list)
  }
}
```

This technique can accommodate input from users who might specify a single value or multiple values.

---

## Summary

By combining complex types (object, list, map), validation rules, conditionals, loops, and environment-specific variable files, you can build Terraform configurations that are both flexible and strongly validated. This ensures that your infrastructure code remains robust, maintainable, and safe from accidental misconfigurations. 

Advanced variable usage in Terraform often means:
1. Enforcing strict schemas for object variables.
2. Using validation rules to reject invalid user input early.
3. Leveraging `locals` for constructing sophisticated default values or transformations.
4. Employing `for_each` loops with variable maps for dynamic resource generation.
5. Relying on environment-specific `.tfvars` files to easily switch between configurations.

Mastering these patterns will significantly improve how you manage and scale infrastructure code across different use cases and environments.