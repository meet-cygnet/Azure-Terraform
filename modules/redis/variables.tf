variable "redis_name" {
  description = "The name of the Redis instance"
  type        = string
}

variable "location" {
  description = "The location/region where the Redis instance will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Redis instance"
  type        = string
}

variable "capacity" {
  description = "The size of the Redis cache to deploy"
  type        = number
  default     = 2
}

variable "family" {
  description = "The SKU family/pricing group to use"
  type        = string
  default     = "C"
}

variable "sku_name" {
  description = "The SKU of Redis to use"
  type        = string
  default     = "Standard"
}
variable "subnet_id" {
  description = "The ID of the Subnet within which the Redis Cache should be deployed"
  type        = string
  default     = null
}

variable "private_static_ip_address" {
  description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network"
  type        = string
  default     = null
}

variable "shard_count" {
  description = "The number of Shards to create on the Redis Cluster"
  type        = number
  default     = null
}

variable "zones" {
  description = "Specifies the Availability Zones in which this Redis Cache should be located"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "redis_configuration" {
  description = "Redis configuration options"
  type = object({
    enable_authentication           = optional(bool, true)
    maxmemory_policy                = optional(string, "volatile-lru")
    notify_keyspace_events          = optional(string, "")
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxfragmentationmemory_reserved = optional(number)
    rdb_backup_enabled              = optional(bool, false)
    rdb_backup_frequency            = optional(number)
    rdb_backup_max_snapshot_count   = optional(number)
    rdb_storage_connection_string   = optional(string)
  })
  default = null
}

variable "patch_schedules" {
  description = "A list of patch schedules"
  type = list(object({
    day_of_week    = string
    start_hour_utc = number
  }))
  default = null
}

variable "private_endpoint_enabled" {
  description = "Whether to create a private endpoint for the Redis Cache"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint"
  type        = string
  default     = null
} 