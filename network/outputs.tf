# Resource Group outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = module.resource_group.resource_group_id
}

# VNet outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.vnet.vnet_name
}

# Subnet outputs
output "subnet_ids" {
  description = "IDs of all subnets"
  value = {
    vm        = module.subnet_vm.subnet_id
    agic      = module.subnet_agic.subnet_id
    endpoints = module.subnet_endpoints.subnet_id
    aks       = module.subnet_aks.subnet_id
    database  = module.subnet_database.subnet_id
  }
}

# AKS outputs
# output "aks_id" {
#   description = "ID of the AKS cluster"
#   value       = module.aks.aks_id
# }

# output "aks_fqdn" {
#   description = "FQDN of the AKS cluster"
#   value       = module.aks.aks_fqdn
# }

# output "aks_private_fqdn" {
#   description = "Private FQDN of the AKS cluster"
#   value       = module.aks.aks_private_fqdn
# }

# Application Gateway outputs
# output "app_gateway_id" {
#   description = "ID of the Application Gateway"
#   value       = module.app_gateway.ag_id
# }

# output "app_gateway_name" {
#   description = "Name of the Application Gateway"
#   value       = module.app_gateway.ag_name
# }

# output "app_gateway_private_ip" {
#   description = "Private IP address of the Application Gateway"
#   value       = module.app_gateway.ag_private_ip
# }

# NSG Outputs
output "apim_nsg_id" {
  description = "ID of the APIM NSG"
  value       = module.nsg_apim.nsg_id
}

output "agic_nsg_id" {
  description = "ID of the AGIC NSG"
  value       = module.nsg_agic.nsg_id
}

output "endpoints_nsg_id" {
  description = "ID of the Endpoints NSG"
  value       = module.nsg_endpoints.nsg_id
}

output "vm_nsg_id" {
  description = "ID of the VM NSG"
  value       = module.nsg_vm.nsg_id
}

output "aks_nsg_id" {
  description = "ID of the AKS NSG"
  value       = module.nsg_aks.nsg_id
}

output "database_nsg_id" {
  description = "ID of the database NSG"
  value       = module.nsg_database.nsg_id
}

# ACR outputs
# output "acr_id" {
#   description = "ID of the Azure Container Registry"
#   value       = module.acr.acr_id
# }

# output "acr_login_server" {
#   description = "Login server of the Azure Container Registry"
#   value       = module.acr.acr_login_server
# }


# # AGIC outputs
# output "agic_helm_release_name" {
#   description = "Name of the AGIC Helm release"
#   value       = module.agic.helm_release_name
# }

# output "agic_helm_release_namespace" {
#   description = "Namespace where AGIC is installed"
#   value       = module.agic.helm_release_namespace
# }

# output "agic_helm_release_status" {
#   description = "Status of the AGIC Helm release"
#   value       = module.agic.helm_release_status
# }

# Identity outputs
# output "identity_id" {
#   description = "ID of the user-assigned identity used by AKS, AGIC, and App Gateway"
#   value       = module.identity.identity_id
# }

# output "identity_client_id" {
#   description = "Client ID of the user-assigned identity used by AKS, AGIC, and App Gateway"
#   value       = module.identity.identity_client_id
# }

# output "identity_principal_id" {
#   description = "Principal ID of the user-assigned identity used by AKS, AGIC, and App Gateway"
#   value       = module.identity.identity_principal_id
# }

