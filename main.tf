# Terraform configuration for simple-todo-app
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Create app config file automatically
resource "local_file" "app_config" {
  filename = "${path.module}/../app-config.json"
  content  = jsonencode({
    app_name    = var.app_name
    version     = var.app_version
    port        = var.app_port
    environment = var.environment
    author      = "Prakash Shinde"
  })
}

# Create .env file automatically
resource "local_file" "env_file" {
  filename = "${path.module}/../.env"
  content  = <<-EOT
    APP_NAME=${var.app_name}
    PORT=${var.app_port}
    NODE_ENV=${var.environment}
    VERSION=${var.app_version}
  EOT
}

