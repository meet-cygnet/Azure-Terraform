variable "cosmosdb_name" {
  description = "The name of the Cosmos DB account"
  type        = string
}

variable "location" {
  description = "The location/region where the Cosmos DB account will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account"
  type        = string
}

variable "offer_type" {
  description = "The offer type to use for Cosmos DB"
  type        = string
  default     = "Standard"
}

variable "enable_free_tier" {
  description = "Enable the free tier for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "ip_range_filter" {
  description = "Cosmos DB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account"
  type        = string
  default     = null
}

variable "consistency_level" {
  description = "The consistency level for the Cosmos DB account"
  type        = string
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "The max interval in seconds for the consistency policy"
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "The max staleness prefix for the consistency policy"
  type        = number
  default     = 100
}

variable "capabilities" {
  description = "The capabilities to enable for this Cosmos DB account"
  type        = list(string)
  default     = []
}

variable "geo_locations" {
  description = "The geo locations for the Cosmos DB account"
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
}

variable "backup" {
  description = "The backup configuration for the Cosmos DB account"
  type = object({
    type                = string
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
  })
  default = null
}

variable "identity_type" {
  description = "The type of identity to use for the Cosmos DB account"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "databases" {
  description = "The MongoDB databases to create"
  type = map(object({
    throughput = optional(number)
    autoscale_settings = optional(object({
      max_throughput = number
    }))
  }))
  default = {}
}

variable "collections" {
  description = "The MongoDB collections to create"
  type = list(object({
    name                = string
    database_name       = string
    shard_key           = string
    throughput          = optional(number)
    autoscale_settings = optional(object({
      max_throughput = number
    }))
    indexes = optional(list(object({
      keys   = list(string)
      unique = optional(bool, false)
    })), [])
  }))
  default = []
}

variable "private_endpoint_enabled" {
  description = "Whether to create a private endpoint for the Cosmos DB account"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint"
  type        = string
  default     = null
} 