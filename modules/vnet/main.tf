resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags
} 

# resource "azurerm_monitor_diagnostic_setting" "settings" {
#   name                       = "DiagnosticsSettings"
#   target_resource_id         = azurerm_virtual_network.vnet.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   enabled_log {
#     category = "VMProtectionAlerts"
#   }

#   metric {
#     category = "AllMetrics"
#   }
# }