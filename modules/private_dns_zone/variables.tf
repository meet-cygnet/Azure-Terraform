variable "zone_name" {
  description = "The name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the Private DNS Zone will be created"
  type        = string
}

variable "vnet_link_name" {
  description = "The name of the Virtual Network Link"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the Virtual Network that should be linked to the DNS Zone"
  type        = string
}

variable "registration_enabled" {
  description = "Whether auto-registration of virtual machine records in the virtual network in the Private DNS zone is enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
} 