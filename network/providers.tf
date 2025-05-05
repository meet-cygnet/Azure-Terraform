terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
}

# provider "helm" {
#   kubernetes {
#     host                   = module.aks.kube_config.0.host
#     client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
#     client_key             = base64decode(module.aks.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
#   }
# }

# provider "kubernetes" {
#   host                   = module.aks.kube_config.0.host
#   client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
#   client_key             = base64decode(module.aks.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
#   # config_path            = "~/.kube/config"
# }
