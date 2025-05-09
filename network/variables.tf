###################### Common Variables ######################
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
################### AKS Variables ###################

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

################### VM Variables ###################

variable vm_security_rules {
  description = "Security rules for the VM"
  type = list(object({
    name                           = string
    priority                       = number
    direction                      = string
    access                         = string
    protocol                       = string
    source_port_range              = optional(string)
    destination_port_range         = optional(string)
    source_port_ranges             = optional(list(string))
    destination_port_ranges        = optional(list(string))
    source_address_prefix          = optional(string)
    destination_address_prefix     = optional(string)
    source_address_prefixes        = optional(list(string))
    destination_address_prefixes   = optional(list(string))
  }))
}


#####################################################
# variable "ag_name" {
#   description = "Name of the Application Gateway"
#   type        = string
#   default     = "ag-dev"
# }

# variable "ag_sku_name" {
#   description = "SKU name of the Application Gateway"
#   type        = string
#   default     = "Standard_v2"
# }

# variable "ag_sku_tier" {
#   description = "SKU tier of the Application Gateway"
#   type        = string
#   default     = "Standard_v2"
# }
# variable "ag_sku_tier" {
#   description = "SKU tier of the Application Gateway"
#   type        = string
#   default     = "Standard_v2"
# }

# variable "ag_capacity" {
#   description = "Capacity of the Application Gateway"
#   type        = number
#   default     = 2
# }
# variable "ag_capacity" {
#   description = "Capacity of the Application Gateway"
#   type        = number
#   default     = 2
# }

# # AGIC variables
# variable "agic_chart_version" {
#   description = "Version of the AGIC Helm chart"
#   type        = string
#   default     = "1.7.5"
# }

# variable "app_gateway_use_private_ip" {
#   description = "Whether to use private IP for the Application Gateway"
#   type        = bool
#   default     = false
# }
# variable "app_gateway_use_private_ip" {
#   description = "Whether to use private IP for the Application Gateway"
#   type        = bool
#   default     = false
# }

# variable "agic_verbosity_level" {
#   description = "Verbosity level of AGIC logs"
#   type        = number
#   default     = 3
# }
# variable "agic_verbosity_level" {
#   description = "Verbosity level of AGIC logs"
#   type        = number
#   default     = 3
# }

# variable "agic_reconcile_period_seconds" {
#   description = "Reconciliation period in seconds for AGIC"
#   type        = number
#   default     = 30
# }
# variable "agic_reconcile_period_seconds" {
#   description = "Reconciliation period in seconds for AGIC"
#   type        = number
#   default     = 30
# }

# variable "agic_namespace" {
#   description = "Namespace where AGIC will be installed"
#   type        = string
#   default     = "default"
# }
# variable "agic_namespace" {
#   description = "Namespace where AGIC will be installed"
#   type        = string
#   default     = "default"
# }

# variable "agic_service_account_name" {
#   description = "Name of the service account for AGIC"
#   type        = string
#   default     = "ingress-azure"
# }
