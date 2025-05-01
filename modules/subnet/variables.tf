variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 

variable "enable_delegation" {
  description = "Enable delegation for the subnet"
  type        = bool
  default     = false
  
}
variable "delegation_service_name" {
  description = "Service name for delegation"
  type        = string
  default     = ""
}