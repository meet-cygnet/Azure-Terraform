variable "agic_chart_version" {
  description = "Version of the AGIC Helm chart"
  type        = string
  default     = "1.7.5"
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

# variable "identity_client_id" {
#   description = "Client ID of the user-assigned managed identity"
#   type        = string
# }

variable "verbosity_level" {
  description = "Verbosity level of AGIC logs"
  type        = number
  default     = 3
}

variable "reconcile_period_seconds" {
  description = "Reconciliation period in seconds for AGIC"
  type        = number
  default     = 30
}

variable "namespace" {
  description = "Namespace where AGIC will be installed"
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "Name of the service account for AGIC"
  type        = string
  default     = "ingress-azure"
}

variable "federated_identity_credential_name" {
  description = "Name of the federated identity credential"
  type        = string
  default     = "agic-federated-credential"
}