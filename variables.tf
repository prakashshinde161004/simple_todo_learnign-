variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "simple-todo-app"
}

variable "app_version" {
  description = "Version of the application"
  type        = string
  default     = "1.0.0"
}

variable "app_port" {
  description = "Port the app runs on"
  type        = number
  default     = 3000
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

