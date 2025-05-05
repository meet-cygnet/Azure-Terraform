variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the managed cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes"
  type        = string
}

# variable "private_dns_zone_id" {
#   description = "ID of the private DNS zone for the AKS cluster"
#   type        = string
# }

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "default_node_pool_node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "default_node_pool_vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "default_node_pool_os_disk_size_gb" {
  description = "Size of the OS Disk for each agent"
  type        = number
  default     = 30
}

variable "subnet_id" {
  description = "ID of the subnet for deployment"
  type        = string
}

variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling"
  type        = bool
  default     = false
}

variable "min_count" {
  description = "Minimum nodes for auto-scaling"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum nodes for auto-scaling"
  type        = number
  default     = 3
}

variable "max_pods" {
  description = "Maximum number of pods per node"
  type        = number
  default     = 30
}

variable "service_cidr" {
  description = "Network range for Kubernetes service"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP for cluster service discovery"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge IP address"
  type        = string
  default     = "172.17.0.1/16"
}

variable "tags" {
  description = "Mapping of tags for the resource"
  type        = map(string)
  default     = {}
}

variable "outbound_type" {
  description = "Outbound type for the AKS cluster"
  type        = string
  default     = "userDefinedRouting"
}

# variable "user_assigned_identity_id" {
#   description = "The ID of the User Assigned Identity to use for the AKS cluster"
#   type        = string
# } 