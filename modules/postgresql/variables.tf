variable "name" {
  description = "The name of the PostgreSQL server"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
}

variable "admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable postgres_version{
  description = "postgresql version"
  type = string 
  default = "16"
}

variable public_network_access_enabled{
  description = "public_network_access_enabled"
  type = bool
  default = false
}


variable "sku_name" {
  description = "The SKU name, e.g., Standard_B1ms"
  type        = string
}

variable "postgresql_version" {
  description = "PostgreSQL version (e.g., 14)"
  type        = string
  default     = "14"
}

variable "storage_mb" {
  description = "Max storage size in MB"
  type        = number
  default     = 32768
}

variable "storage_tier" {
  description = "Storage tier"
  type        = string
  default = "P4"
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "1"
}

# variable "delegated_subnet_id" {
#   description = "ID of the delegated subnet for Flexible Server"
#   type        = string
# }

# variable "private_dns_zone_id" {
#   description = "ID of the private DNS zone"
#   type        = string
# }

variable "enable_ha" {
  type    = bool
  default = false
}

variable "ha_mode" {
  description = "High availability mode (e.g., ZoneRedundant or Disabled)"
  type        = string
  default     = "ZoneRedundant"
}

variable "enable_azure_ad_auth" {
  description = "enable_azure_ad_auth"
  type = bool
  default = false
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
