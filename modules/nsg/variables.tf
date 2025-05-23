variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to associate with the NSG"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "security_rules" {
  description = "List of security rules"
  type = list(object({
    name                           = string
    priority                       = number
    direction                      = string
    access                         = string
    protocol                       = string
    source_port_range              = optional(string)
    destination_port_range         = optional(string)
    source_port_ranges             = optional(list(string))
    destination_port_ranges        = optional(list(string))
    source_address_prefix          = optional(string)
    destination_address_prefix     = optional(string)
    source_address_prefixes        = optional(list(string))
    destination_address_prefixes   = optional(list(string))
  }))

  # Default rules to match your current static config
  default = [
  ]
}
