variable "identity_name" {
  description = "Name of the user-assigned identity"
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

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  description = "Map of role assignments to be created for the identity"
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
  default = {}
} 