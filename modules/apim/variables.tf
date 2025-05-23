variable "name" {
  description = "The name of the API Management service."
  type        = string
}

variable "location" {
  description = "Azure region where the resource will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "publisher_name" {
  description = "The name of the publisher."
  type        = string
}

variable "publisher_email" {
  description = "The email of the publisher."
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the API Management service. E.g., Developer_1, Basic_1, Premium_1"
  type        = string
}

variable "identity_type" {
  description = "Type of managed identity to use. Possible values: SystemAssigned, UserAssigned, SystemAssigned,UserAssigned, or None"
  type        = string
  default     = "SystemAssigned"
}

variable "subnet_id" {
  description = "The ID of the subnet for VNet integration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "virtual_network_type" {
  description = "The type of virtual network configuration. Possible values: None, External, Internal."
  type        = string
  default     = "Internal"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled. Default is true."
  type        = bool
  default     = false
}

# variable "virtual_network_configuration" {
#   description = <<EOT
# Optional virtual network configuration block.
# Example:
# {
#   subnet_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
# }
# EOT
#   type = object({
#     subnet_id = string
#   })
#   default = null
# }

variable "public_ip_address_id" {
  description = "Optional Public IP Address ID for external-facing APIM (Premium tier)."
  type        = string
  default     = null
}

