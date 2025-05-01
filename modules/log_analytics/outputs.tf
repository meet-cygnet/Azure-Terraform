output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_primary_key" {
  description = "The Primary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
  sensitive   = true
}

output "monitor_workspace_id" {
  description = "The ID of the Azure Monitor workspace"
  value       = azurerm_monitor_workspace.amw.id
} 