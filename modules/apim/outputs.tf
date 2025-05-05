output "apim_id" {
  description = "The ID of the API Management instance."
  value       = azurerm_api_management.this.id
}

output "apim_name" {
  description = "The name of the API Management instance."
  value       = azurerm_api_management.this.name
}

output "apim_hostname" {
  description = "The hostname of the API Management instance."
  value       = azurerm_api_management.this.gateway_url
}
