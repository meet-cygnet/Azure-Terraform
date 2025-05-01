output "identity_id" {
  description = "ID of the user-assigned identity"
  value       = azurerm_user_assigned_identity.identity.id
}

output "identity_client_id" {
  description = "Client ID of the user-assigned identity"
  value       = azurerm_user_assigned_identity.identity.client_id
}

output "identity_principal_id" {
  description = "Principal ID of the user-assigned identity"
  value       = azurerm_user_assigned_identity.identity.principal_id
} 