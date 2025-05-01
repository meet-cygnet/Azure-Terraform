resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_monitor_workspace" "amw" {
  name                = var.monitor_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
} 
