# =============================================
# Terraform — manages Kubernetes infrastructure
# Instead of kubectl apply manually, Terraform
# creates/updates/deletes K8s resources as code!
# =============================================

terraform {
  required_providers {
    # Kubernetes provider — talks to your K8s cluster
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    # Local provider — creates local files
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# =============================================
# PROVIDER — connect to Minikube cluster
# =============================================
provider "kubernetes" {
  config_path    = "~/.kube/config"   # kubeconfig file path
  config_context = "minikube"         # use minikube context
}

# =============================================
# RESOURCE 1 — Create Kubernetes Namespace
# Like creating a folder inside your cluster
# =============================================
resource "kubernetes_namespace" "todo_namespace" {
  metadata {
    name = var.namespace
    labels = {
      app         = "todo-app"
      environment = var.environment
    }
  }
}

# =============================================
# RESOURCE 2 — Create ConfigMap via Terraform
# Same as kubectl apply -f configmap.yaml
# =============================================
resource "kubernetes_config_map" "todo_config" {
  metadata {
    name      = "todo-config"
    namespace = kubernetes_namespace.todo_namespace.metadata[0].name
  }

  data = {
    NODE_ENV    = var.environment
    PORT        = tostring(var.app_port)
    APP_NAME    = var.app_name
    APP_VERSION = var.app_version
  }
}

# =============================================
# RESOURCE 3 — Create Deployment via Terraform
# Same as kubectl apply -f deployment.yaml
# =============================================
resource "kubernetes_deployment" "todo_deployment" {
  metadata {
    name      = "todo-deployment"
    namespace = kubernetes_namespace.todo_namespace.metadata[0].name
    labels = {
      app = "todo-app"
    }
  }

  spec {
    replicas = var.replicas   # controlled by variable!

    selector {
      match_labels = {
        app = "todo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "todo-app"
        }
      }

      spec {
        container {
          name  = "todo-container"
          image = "simple-todo-app:latest"
          image_pull_policy = "Never"

          port {
            container_port = var.app_port
          }

          # Resource limits
          resources {
            requests = {
              memory = "64Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "250m"
            }
          }

          # Liveness Probe
          liveness_probe {
            http_get {
              path = "/health"
              port = var.app_port
            }
            initial_delay_seconds = 10
            period_seconds        = 30
          }
        }
      }
    }
  }
}

# =============================================
# RESOURCE 4 — Create Service via Terraform
# Same as kubectl apply -f service.yaml
# =============================================
resource "kubernetes_service" "todo_service" {
  metadata {
    name      = "todo-service"
    namespace = kubernetes_namespace.todo_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "todo-app"
    }

    type = "NodePort"

    port {
      protocol    = "TCP"
      port        = var.app_port
      target_port = var.app_port
      node_port   = 30001
    }
  }
}

# =============================================
# LOCAL FILE — generate .env for local dev
# =============================================
resource "local_file" "env_file" {
  filename = "${path.module}/.env"
  content  = <<-EOT
    APP_NAME=${var.app_name}
    PORT=${var.app_port}
    NODE_ENV=${var.environment}
    VERSION=${var.app_version}
  EOT
}
