resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                          = var.namespace_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.sku == "Premium" ? var.capacity : null
  tags                          = var.tags
  public_network_access_enabled = var.public_network_access_enabled
  # network_rule_set {
  #   network_rules {
  #       subnet_id = var.subnet_id
  #       }
  #   }
  premium_messaging_partitions = var.premium_messaging_partitions
}

resource "azurerm_servicebus_queue" "servicebus_queue" {
  count        = var.enable_queue ? 1 : 0
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace.id
  # partitioning_enabled = false
}
