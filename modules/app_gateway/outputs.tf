output "ag_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.ag.id
}

output "ag_backend_pool_id" {
  description = "ID of the backend address pool"
  value       = [for pool in azurerm_application_gateway.ag.backend_address_pool : pool.id if pool.name == "${var.ag_name}-be-pool"][0]
}

output "ag_private_ip" {
  description = "Private IP address of the Application Gateway"
  value       = [for ip in azurerm_application_gateway.ag.frontend_ip_configuration : ip.private_ip_address if ip.name == "${var.ag_name}-fe-ip"][0]
} 

output "ag_name" {
  description = "Name of the Application Gateway"
  value       = azurerm_application_gateway.ag.name
}

output "identity_principal_id" {
  description = "Principal ID of the identity"
  value       = azurerm_application_gateway.ag.identity[0].principal_id
}

# output "identity_client_id" {
#   description = "Client ID of the identity"
#   value       = azurerm_application_gateway.ag.identity[0].client_id
# }


