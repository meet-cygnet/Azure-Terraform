variable "redis_name" {
  description = "Name of the Redis Cache instance"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name: Basic, Standard, or Premium"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "The size of the Redis cache (e.g. 0 = C0/P0, 1 = C1/P1, ... up to 6)"
  type        = number
  default     = 1
}

variable "family" {
  description = "The SKU family (C = Basic/Standard, P = Premium)"
  type        = string
  default     = "C"
}

# variable "subnet_id" {
#   description = "The ID of the subnet to deploy the Redis cache"
#   type        = string
# }

variable "public_network_access_enabled" {
  description = "Whether to enable public network access"
  type        = bool
  default     = false
}

# variable "private_static_ip_address" {
#   description = "The static IP address to assign to the Redis cache"
#   type        = string
# }

# variable "shard_count" {
#   description = "The number of shards to deploy the Redis cache"
#   type        = number
#   default     = 1
# }

# variable "zones" {
#   description = "The availability zones to deploy the Redis cache"
#   type        = list(string)
#   default     = ["1", "2", "3"]
# }


variable "non_ssl_port_enabled" {
  description = "Whether to enable the non-SSL port (6379)"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for SSL (e.g. '1.2')"
  type        = string
  default     = "1.2"
}

variable "redis_version" {
  description = "Redis version (4 or 6)"
  type        = string
  default     = "6"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
