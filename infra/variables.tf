######################## Common Variables #########################
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location for the resource group"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., Development, Production)"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}
######################## AKS VARIABLES #########################################
variable "vnet_link_name" {
  description = "The name of the Virtual Network Link for the AKS private DNS zone"
  type        = string
}

variable "aks_subnet_name" {
  description = "aks subnet"
  type        = string
}
variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_kubernetes_version" {
  description = "Version of Kubernetes for AKS cluster"
  type        = string
}

variable "aks_service_cidr" {
  description = "Network range for Kubernetes service in AKS cluster. Should be a subset of the address space."
  type        = string
}

variable "aks_dns_service_ip" {
  description = "IP for cluster service discovery in AKS cluster. Should be within the service CIDR range."
  type        = string
}
######################### POSTGRESQL VARIABLES ######################

variable "postgresql_admin_username" {
  description = "The admin username for the postgresql server"
  type        = string
}

variable "postgresql_admin_password" {
  description = "The admin password for the postgresql server"
  type        = string
}

variable "postgresql_name" {
  description = "name of postgresql server"
  type        = string
}

variable "postgresql_sku_name" {
  description = "value of sku name"
  type        = string
}

variable "postgresql_version" {
  description = "version of postgresql"
  type        = string
}

# variable "postgresql_ha_mode"{
#   description = "ha mode of postgresql"
#   type        = string
# }

variable "enable_ha" {
  description = "enable_ha"
  type        = bool
}

variable "enable_azure_ad_auth" {
  description = "enable_azure_ad_auth"
  type        = bool
}

variable "postgresql_backup_retention_days" {
  description = "postgresql_backup_retention_days"
  type        = number
}

variable "storage_tier" {
  description = "storage_tier"
  type        = string
}

###################################################################
##################### REDIS VARIABLES ##############################

variable "redis_name" {
  description = "name of redis"
  type        = string
}

variable "redis_sku_name" {
  description = "sku name of redis"
  type        = string
}

variable "redis_family" {
  description = "family of redis"
  type        = string
}

variable "redis_capacity" {
  description = "capacity of redis"
  type        = number
}

variable "redis_non_ssl_port_enabled" {
  description = "non ssl port enabled of redis"
  type        = bool
}

variable "redis_minimum_tls_version" {
  description = "minimum tls version of redis"
  type        = string
}

variable "redis_version" {
  description = "version of redis"
  type        = string
}

# variable "redis_shard_count" {
#   description = "shard count of redis"
#   type        = number
# }

# variable "redis_zones" {
#   description = "zones of redis"
#   type        = list(string)
# }

# variable "public_network_access_enabled" {
#   description = "Whether to enable public network access"
#   type        = bool
# }

################## cosmosdb variables##########################################
variable "cosmosdb_name" {
  description = "name of cosmosdb"
  type        = string
}

variable "database_name" {
  description = "name of database"
  type        = string
}

variable "capabilities" {
  description = "List of capabilities for the Cosmos DB account"
  type        = list(string)
  default     = []
}

# variable "collection_name" {
#   description = "name of collection"
#   type        = string
# }

variable "shard_key" {
  description = "shard key"
  type        = string
}

variable "offer_type" {
  description = "offer type"
  type        = string
}

variable "consistency_level" {
  description = "consistency level"
  type        = string
}

variable "cosmosdb_kind" {
  description = "kind of cosmosdb"
  type        = string
}

variable "geo_locations" {
  description = "geo locations"
  type = list(object({
    location          = string
    failover_priority = number
  }))
}

variable "backup" {
  description = "backup"
  type = object({
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
  })
}

variable "identity_type" {
  description = "identity type"
  type        = string
}


##############################################################

# variable "address_space" {
#   description = "The address space for the virtual network"
#   type        = list(string)
# }

# variable "apim_subnet_prefix" {
#   description = "The address prefix for the APIM subnet"
#   type        = string
# }

# variable "agic_subnet_prefix" {
#   description = "The address prefix for the AGIC subnet"
#   type        = string
# }

# variable "reserved_subnet_prefix" {
#   description = "The address prefix for the reserved subnet"
#   type        = string
# }

# variable "endpoints_subnet_prefix" {
#   description = "The address prefix for the endpoints subnet"
#   type        = string
# }

# variable "aks_subnet_prefix" {
#   description = "The address prefix for the AKS subnet"
#   type        = string
# }

# variable "nsg_name" {
#   description = "The name of the network security group"
#   type        = string
# }

# variable "route_table_name" {
#   description = "The name of the route table"
#   type        = string
# }

# variable "route_table_routes" {
#   description = "List of routes to be applied to the route table"
#   type = list(object({
#     name                   = string
#     address_prefix        = string
#     next_hop_type         = string
#     next_hop_in_ip_address = string
#   }))
#   default = [
#     {
#       name                   = "default-route"
#       address_prefix        = "0.0.0.0/0"
#       next_hop_type         = "Internet"
#       next_hop_in_ip_address = null
#     }
#   ]
# }

# variable "nsg_rules" {
#   description = "Network security group rules"
#   type = list(object({
#     name                       = string
#     priority                   = number
#     direction                  = string
#     access                     = string
#     protocol                   = string
#     source_port_range          = string
#     destination_port_range     = string
#     source_address_prefix      = string
#     destination_address_prefix = string
#   }))
#   default = [
#     {
#       name                       = "AllowVnetInBound"
#       priority                   = 100
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "*"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "VirtualNetwork"
#       destination_address_prefix = "VirtualNetwork"
#     },
#     {
#       name                       = "AllowAzureLoadBalancerInBound"
#       priority                   = 110
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "*"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "AzureLoadBalancer"
#       destination_address_prefix = "*"
#     },
#     {
#       name                       = "DenyAllInBound"
#       priority                   = 4096
#       direction                  = "Inbound"
#       access                     = "Deny"
#       protocol                   = "*"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   ]
# }