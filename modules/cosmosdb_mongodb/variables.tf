variable "cluster_name" {
  description = "The name of the MongoDB vCore cluster"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the MongoDB cluster"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the cluster"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the cluster"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "shard_count" {
  description = "The number of shards in the cluster"
  type        = number
  default     = 1
}

variable "compute_tier" {
  description = "The compute tier for the cluster"
  type        = string
  default     = "M10"
}

variable "high_availability_mode" {
  description = "The high availability mode for the cluster"
  type        = string
  default     = "ZoneRedundantPreferred"
}

variable "storage_size_in_gb" {
  description = "The storage size in GB for the cluster"
  type        = number
  default     = 32
}

variable "public_network_access" {
  description = "Public network access for the cluster"
  type        = string
  default     = "Disabled"
}

variable "create_mode" {
  description = "The create mode for the cluster"
  type        = string
  default     = "Default"
}

variable "mongodb_version" {
  description = "The version of the MongoDB cluster"
  type        = string
  default     = "7.0"
}
