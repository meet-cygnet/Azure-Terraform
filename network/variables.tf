variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_spaces" {
  description = "Address spaces for the virtual network"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Address prefixes for subnets"
  type        = map(string)
}

# variable "acr_name" {
#   description = "Name of the Azure Container Registry"
#   type        = string
# }

# variable "acr_sku" {
#   description = "SKU of the Azure Container Registry"
#   type        = string
#   default     = "Premium"
# }

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_kubernetes_version" {
  description = "Version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = "1.32.3"
}

variable "aks_system_node_count" {
  description = "Initial number of nodes in system node pool"
  type        = number
  default     = 1
}

variable "aks_system_node_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "aks_user_node_count" {
  description = "The number of nodes in the user node pool"
  type        = number
  default     = 1
}

variable "aks_user_node_vm_size" {
  description = "The size of the VMs in the user node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_user_node_pool_name" {
  description = "Name of the user node pool"
  type        = string
  default     = "userpool"
}

variable "aks_user_node_pool_os_disk_size_gb" {
  description = "OS disk size in GB for user node pool"
  type        = number
  default     = 128
}

variable "aks_user_node_pool_max_pods" {
  description = "Maximum number of pods per node in user node pool"
  type        = number
  default     = 110
}

variable "aks_user_node_pool_enable_auto_scaling" {
  description = "Whether to enable auto scaling for user node pool"
  type        = bool
  default     = true
}

variable "aks_user_node_pool_min_count" {
  description = "Minimum number of nodes in user node pool when auto scaling is enabled"
  type        = number
  default     = 1
}

variable "aks_user_node_pool_max_count" {
  description = "Maximum number of nodes in user node pool when auto scaling is enabled"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

# variable "client_id" {
#   description = "Azure client ID"
#   type        = string
# }

# variable "client_secret" {
#   description = "Azure client secret"
#   type        = string
# }

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
  default     = "privatelink.azurecr.io"
}

variable "private_dns_registration_enabled" {
  description = "Whether to enable auto-registration of virtual network records in the Private DNS Zone"
  type        = bool
  default     = true
}

# variable "acr_private_dns_zone_name" {
#   description = "Name of the private DNS zone for ACR"
#   type        = string
#   default     = "privatelink.azurecr.io"
# }

variable "aks_private_dns_zone_name" {
  description = "Name of the private DNS zone for AKS"
  type        = string
  # default     = "privatelink.${var.location}.azmk8s.io"
}

variable "ag_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "ag-dev"
}

variable "ag_sku_name" {
  description = "SKU name of the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "ag_sku_tier" {
  description = "SKU tier of the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "ag_capacity" {
  description = "Capacity of the Application Gateway"
  type        = number
  default     = 2
}

# AGIC variables
variable "agic_chart_version" {
  description = "Version of the AGIC Helm chart"
  type        = string
  default     = "1.7.5"
}

variable "app_gateway_use_private_ip" {
  description = "Whether to use private IP for the Application Gateway"
  type        = bool
  default     = false
}

variable "agic_verbosity_level" {
  description = "Verbosity level of AGIC logs"
  type        = number
  default     = 3
}

variable "agic_reconcile_period_seconds" {
  description = "Reconciliation period in seconds for AGIC"
  type        = number
  default     = 30
}

variable "agic_namespace" {
  description = "Namespace where AGIC will be installed"
  type        = string
  default     = "default"
}

variable "agic_service_account_name" {
  description = "Name of the service account for AGIC"
  type        = string
  default     = "ingress-azure"
}

variable "aks_system_node_min_count" {
  description = "Minimum number of nodes in system node pool"
  type        = number
  default     = 1
}

variable "aks_system_node_max_count" {
  description = "Maximum number of nodes in system node pool"
  type        = number
  default     = 3
}

variable "aks_load_balancer_sku" {
  description = "SKU of the load balancer for AKS"
  type        = string
  default     = "standard"
}

variable "aks_outbound_type" {
  description = "Outbound type for AKS cluster"
  type        = string
  default     = "userDefinedRouting"
}

variable "aks_sku_tier" {
  description = "SKU tier for AKS cluster"
  type        = string
  default     = "Standard"
}

variable "aks_node_pool_os_disk_size_gb" {
  description = "OS disk size in GB for AKS node pool"
  type        = number
  default     = 128
}

variable "aks_default_node_pool_os_disk_type" {
  description = "OS disk type for AKS default node pool"
  type        = string
  default     = "Ephemeral"
}

variable "aks_node_pool_max_pods" {
  description = "Maximum number of pods per node in AKS"
  type        = number
  default     = 110
}

variable "aks_default_node_pool_name" {
  description = "Name of the default node pool in AKS"
  type        = string
  default     = "system"
}

variable "aks_private_cluster_enabled" {
  description = "Whether to enable private cluster for AKS"
  type        = bool
  default     = true
}