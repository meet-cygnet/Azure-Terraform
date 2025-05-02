
variable "location" {
  description = "The location/region where the Cosmos DB account will be created"
  type        = string
}

variable "cosmosdb_kind" {
  description = "The kind of the Cosmos DB account"
  type        = string
  default = "MongoDB"
}


variable "capabilities" {
  description = "The capabilities for the Cosmos DB account"
  type        = list(string)
}

variable "geo_locations" {
  description = "The geo locations for the Cosmos DB account"
  type        = list(object({
    location = string
    failover_priority = number
  }))
}

variable "backup" {
  description = "The backup for the Cosmos DB account"
  type        = object({
    type = string
    interval_in_minutes = number
    retention_in_hours = number
  })
}

variable "identity_type" {
  description = "The identity type for the Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account"
  type        = string
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "enable_free_tier" {
  description = "Enable free tier pricing for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "consistency_level" {
  description = "The consistency level to use for this Cosmos DB account"
  type        = string
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated"
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated"
  type        = number
  default     = 100
}

variable "backup_interval_in_minutes" {
  description = "The interval in minutes between two backups"
  type        = number
  default     = 240
}

variable "backup_retention_in_hours" {
  description = "The time in hours that each backup is retained"
  type        = number
  default     = 8
}

variable "network_acl_bypass_for_azure_services" {
  description = "If Azure services can bypass ACLs"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "The name of the MongoDB database"
  type        = string
}

variable "database_throughput" {
  description = "The throughput of the MongoDB database (RU/s)"
  type        = number
  default     = 400
}

variable max_throughput {
  description = "The maximum throughput for the MongoDB database (RU/s)"
  type        = number
  default     = 4000
}

variable "shard_key" {
  description = "The shard key for the MongoDB collection"
  type        = string
}

variable "indexes" {
  description = "The indexes to create on the MongoDB collection"
  type = list(object({
    keys   = list(string)
    unique = bool
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
} 

variable "cosmosdb_name" {
  description = "The name of the Cosmos DB account"
  type        = string
}

variable "offer_type" {
  description = "The offer type for the Cosmos DB account"
  type        = string
}