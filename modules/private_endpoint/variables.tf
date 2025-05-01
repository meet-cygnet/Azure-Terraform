variable "name" {
  description = "The name of the private endpoint"
  type        = string
}

variable "location" {
  description = "The location of the private endpoint"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet for the private endpoint"
  type        = string
}

variable "private_connection_resource_id" {
  description = "The ID of the resource to connect to"
  type        = string
}

variable "subresource_names" {
  description = "The subresource names to connect to"
  type        = list(string)
}   

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the private endpoint"
  type        = map(string)
}

