variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "account_tier" {
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public network access for the storage account"
}