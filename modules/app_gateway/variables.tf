variable "ag_name" {
  description = "Name of the Application Gateway"
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

variable "ag_subnet_id" {
  description = "ID of the subnet for Application Gateway"
  type        = string
}

variable "ag_sku_name" {
  description = "SKU name of the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "ag_sku_tier" {
  description = "SKU tier of the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "ag_capacity" {
  description = "Capacity of the Application Gateway"
  type        = number
  default     = 2
}

# variable "user_assigned_identity_id" {
#   description = "ID of the user assigned identity for Application Gateway"
#   type        = string
# }

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 