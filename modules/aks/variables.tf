variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = "1.32.3"
}

variable "outbound_type" {
  description = "Outbound type"
  type        = string
  default     = "userDefinedRouting"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

# variable "private_dns_zone_id" {
#   description = "ID of the private DNS zone for AKS"
#   type        = string
# }

variable "system_node_count" {
  description = "Initial number of nodes in system node pool"
  type        = number
  default     = 1
}

variable "system_node_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "system_subnet_id" {
  description = "ID of the subnet for system node pool"
  type        = string
}

variable "system_node_min_count" {
  description = "Minimum number of nodes in system node pool"
  type        = number
  default     = 1
}

variable "system_node_max_count" {
  description = "Maximum number of nodes in system node pool"
  type        = number
  default     = 3
}

variable "system_node_labels" {
  description = "Labels to apply to system nodes"
  type        = map(string)
  default     = {
    "nodepool" = "system"
  }
}

variable "private_cluster_enabled" {
  description = "Enable private cluster"
  type        = bool
  default     = true
}

variable "automatic_upgrade_channel" {
  description = "Automatic channel upgrade"
  type        = string
  default     = "none"
}

variable "sku_tier" {
  description = "SKU tier"
  type        = string
  default     = "Standard"
}

variable "node_pool_os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "default_node_pool_os_disk_type" {
  description = "OS disk type"
  type        = string
  default     = "Ephemeral"
}

variable "node_pool_max_pods" {
  description = "Maximum number of pods"
  type        = number
  default     = 110
}

variable "node_pool_availability_zones" {
  description = "Availability zones"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "system"
}


# variable "user_node_count" {
#   description = "Initial number of nodes in user node pool"
#   type        = number
#   default     = 1
# }

# variable "user_node_vm_size" {
#   description = "VM size for user node pool"
#   type        = string
#   default     = "Standard_D4s_v3"
# }

# variable "user_node_min_count" {
#   description = "Minimum number of nodes in user node pool"
#   type        = number
#   default     = 1
# }

# variable "user_node_max_count" {
#   description = "Maximum number of nodes in user node pool"
#   type        = number
#   default     = 5
# }

# variable "user_node_labels" {
#   description = "Labels to apply to user nodes"
#   type        = map(string)
#   default     = {
#     "nodepool" = "user"
#   }
# }

# variable "user_subnet_id" {
#   description = "ID of the subnet for user node pool"
#   type        = string
# }

# variable "dns_service_ip" {
#   description = "IP address for Kubernetes DNS service"
#   type        = string
#   default     = "10.0.0.10"
# }

# variable "service_cidr" {
#   description = "CIDR range for Kubernetes services"
#   type        = string
#   default     = "10.0.0.0/16"
# }


# variable "acr_id" {
#   description = "ID of the Azure Container Registry"
#   type        = string
# }


  # variable "log_analytics_workspace_id" {
  #   description = "ID of the Log Analytics workspace for container insights"
  #   type        = string
  # }

# variable "virtual_network_id" {
#   description = "ID of the virtual network"
#   type        = string
# }

# variable "client_id" {
#   description = "Client ID"
#   type        = string
# }

# variable "identity_id" {
#   description = "ID of the user-assigned identity to use for AKS"
#   type        = string
# }

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 

variable "enable_auto_scaling" {
  type = bool
  default = true
  description = "Enable auto-scaling for the AKS cluster"
}

variable "outbound_type" {
  type = string
  default = "loadBalancer"
  description = "Outbound type for the AKS cluster"
}
