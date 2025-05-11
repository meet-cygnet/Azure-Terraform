variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "eventhub_namespace_name" {
  type        = string
  description = "Name of the Event Hub namespace"
}

variable "processing_units" {
  type        = number
  default     = 1
  description = "Number of Premium processing units"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where private endpoint will be created"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "eventhub_sku" {
  type        = string
  default     = "Standard"
  description = "Event Hub SKU"
}

variable "eventhubs" {
  type = list(object({
    name              = string
    partition_count   = number
    message_retention = number
  }))
  default     = []
  description = "List of Event Hubs to create"
}

variable "authorization_rules" {
  type = list(object({
    name           = string
    eventhub_name  = string
    listen         = bool
    send           = bool
    manage         = bool
  }))
  default     = []
  description = "Authorization rules per Event Hub"
}
