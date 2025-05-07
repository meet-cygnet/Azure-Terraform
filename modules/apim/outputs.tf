output "apim_id" {
  description = "The ID of the API Management instance."
  value       = azurerm_api_management.apim.id
}

output "apim_name" {
  description = "The name of the API Management instance."
  value       = azurerm_api_management.apim.name
}

output "apim_hostname" {
  description = "The hostname of the API Management instance."
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_gateway_url" {
  description = "The gateway URL of the API Management instance."
  value       = azurerm_api_management.apim.gateway_url
}