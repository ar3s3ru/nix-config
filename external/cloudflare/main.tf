terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.20.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.15.0"
    }
  }
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token used to perform authenticated requests"
  sensitive   = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "tailscale_api_token" {
  type        = string
  description = "Tailscale API token to authenticate to the Tailscale account"
  sensitive   = true
}

provider "tailscale" {
  api_key = var.tailscale_api_token
}
