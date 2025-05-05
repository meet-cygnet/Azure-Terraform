variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username"
  type        = string
}

variable "os_type" {
  description = "The operating system type (linux or windows)"
  type        = string
}

variable "managed_disk_type" {
  description = "The managed disk type"
  type        = string
  default     = "Standard_LRS"
}

variable "vm_publisher" {
  description = "The VM publisher"
  type        = string
}

variable "vm_offer" {
  description = "The VM offer"
  type        = string
}

variable "vm_sku" {
  description = "The VM SKU"
  type        = string
}

variable "vm_version" {
  description = "The VM version"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the VM will be created"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
  default     = {}
}

variable "use_existing_ssh_key" {
  description = "Whether to use an existing SSH public key"
  type        = bool
  default     = false
}

variable "existing_ssh_public_key" {
  description = "The existing SSH public key for Linux"
  type        = string
  default     = ""
}
