output "helm_release_name" {
  description = "Name of the AGIC Helm release"
  value       = helm_release.agic.name
}

output "helm_release_namespace" {
  description = "Namespace where AGIC is installed"
  value       = helm_release.agic.namespace
}

output "helm_release_status" {
  description = "Status of the AGIC Helm release"
  value       = helm_release.agic.status
}

# output "service_account_name" {
#   description = "Name of the service account used by AGIC"
#   value       = kubernetes_service_account.agic.metadata[0].name
# }

# output "federated_identity_credential_name" {
#   description = "Name of the federated identity credential"
#   value       = azurerm_federated_identity_credential.agic.name
# } 