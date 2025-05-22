
#################### Resource group variables ####################

variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable location {
  description = "Azure region for the resources"
  type        = string
}

variable tags {
  description = "Tags to apply to the resources"
  type        = map(string)
}

######################Vnet variables#############################################
variable vnet_name {
  description = "Name of the virtual network"
  type        = string
}

variable vnet_address_space {
  description = "Address space for the virtual network"
  type        = list(string)
}

######################## Subnet variables ##############################

variable subnet_address_prefix {
  description = "Address prefix for the subnet"
  type        = map(string)
}

variable enable_delegation {
  description = "Enable delegation for the subnet"
  type        = bool
  default     = false
}

variable delegation_service_name {
  description = "Name of the delegation service"
  type        = string
  default     = null
}

########################## aks variables #############################
variable aks_cluster_name {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_route_table_name"{
  description = "Name of the route table for AKS cluster"
  type        = string
}
# variable aks_security_rules {
#   description = "Security rules for the AKS cluster"
#   type        = list(object({
#     name                           = string
#     priority                       = number
#     direction                      = string
#     access                         = string
#     protocol                       = string
#     source_port_range              = optional(string)
#     destination_port_range         = optional(string)
#     source_port_ranges             = optional(list(string))
#     destination_port_ranges        = optional(list(string))
#     source_address_prefix          = optional(string)
#     destination_address_prefix     = optional(string)
#     source_address_prefixes        = optional(list(string))
#     destination_address_prefixes   = optional(list(string))
#   }))
# }

########################################################################
######################## VM Variables ############################

variable "linux_vm_name" {
  description = "The name of the Linux VM"
  type        = string
}

variable "linux_vm_location" {
  description = "The Azure region where the VM will be created"
  type        = string
}

variable "linux_vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "linux_vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "linux_vm_os_type" {
  description = "The operating system type (linux)"
  type        = string
  default     = "linux"
}

variable "linux_vm_use_existing_ssh_key" {
  description = "Whether to use an existing SSH key"
  type        = bool
}

variable "linux_vm_version" {
  description = "The version of the VM image"
  type        = string
}

variable "linux_vm_sku" {
  description = "The SKU of the VM image"
  type        = string
}

variable "linux_vm_publisher" {
  description = "The publisher of the VM image"
  type        = string
}

variable "linux_vm_offer" {
  description = "The offer of the VM image"
  type        = string
}

variable "enable_public_ip" {
  description = "Whether to enable a public IP for the VM"
  type        = bool
}

variable vm_security_rules {
  description = "Security rules for the VM"
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
}

####################### App_gateway variables ######################
# variable ag_name {
#   description = "Name of the Application Gateway"
#   type        = string
# }

# variable ag_sku_name {
#   description = "SKU name of the Application Gateway"
#   type        = string
#   default     = "Standard_v2"
# }

# variable "ag_sku_tier" {
#   description = "SKU tier of the Application Gateway"
#   type        = string
#   default     = "Standard_v2"
# }

# variable "ag_capacity" {
#   description = "Capacity of the Application Gateway"
#   type        = number
#   default     = 2
# }

