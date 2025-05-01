output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "private_endpoint_ip" {
  description = "Private IP address of the ACR private endpoint"
  value       = azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address
} 
