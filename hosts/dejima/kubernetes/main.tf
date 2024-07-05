terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token to use with CertManager"
  sensitive   = true
}

variable "kubernetes_token" {
  type        = string
  description = "Kubernetes token to access the API"
  sensitive   = true
}

variable "tailscale_oauth_client_id" {
  type        = string
  description = "Tailscale OAuth client ID for the Kubernetes operator"
  sensitive   = true
}

variable "tailscale_oauth_client_secret" {
  type        = string
  description = "Tailscale OAuth client secret for the Kubernetes operator"
  sensitive   = true
}


provider "helm" {
  kubernetes {
    host  = "https://tailscale-operator.tail2ff90.ts.net"
    token = var.kubernetes_token
  }
}

provider "kubernetes" {
  host  = "https://tailscale-operator.tail2ff90.ts.net"
  token = var.kubernetes_token
}
