output "private_endpoint_id" {
  value       = azurerm_private_endpoint.private_endpoint.id
  description = "ID of the created private endpoint"
}

output "network_interface_id" {
  value       = azurerm_private_endpoint.private_endpoint.network_interface[0].id
  description = "ID of the network interface for the private endpoint"
}
