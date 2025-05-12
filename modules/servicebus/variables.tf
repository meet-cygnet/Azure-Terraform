variable "namespace_name" {
  type        = string
  description = "Name of the Service Bus namespace."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "sku" {
  type        = string
  default     = "Premium"
  description = "Service Bus SKU (Premium required for private endpoint)."
}

variable "capacity" {
  type        = number
  default     = 1
  description = "Capacity (only required for Premium)."
}

variable "enable_queue" {
  type    = bool
  default = false
}

variable "queue_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "subnet_id" {
#   type        = string
#   description = "Subnet ID for the private endpoint."
# }

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public network access for the Service Bus namespace."
}

variable "premium_messaging_partitions" {
  type        = number
  default     = 1
  description = "Number of messaging partitions for Premium SKU."
}
