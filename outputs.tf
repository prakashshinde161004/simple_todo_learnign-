output "app_name" {
  description = "Application name"
  value       = var.app_name
}

output "app_port" {
  description = "Application port"
  value       = var.app_port
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "config_file_path" {
  description = "Path of generated config file"
  value       = local_file.app_config.filename
}

