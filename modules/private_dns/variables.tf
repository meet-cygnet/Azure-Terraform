variable "private_dns_zone_name" {
  description = "The name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to link with the Private DNS Zone"
  type        = string
}

variable "registration_enabled" {
  description = "Whether to enable auto-registration of virtual network records in the Private DNS Zone"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 