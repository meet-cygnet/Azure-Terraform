resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.eventhub_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.eventhub_sku
  capacity            = var.processing_units
  public_network_access_enabled = false
  tags                = var.tags
}

resource "azurerm_eventhub" "eventhubs" {
  count               = length(var.eventhubs)
  name                = var.eventhubs[count.index].name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhubs[count.index].partition_count
  message_retention   = var.eventhubs[count.index].message_retention
}

resource "azurerm_eventhub_authorization_rule" "eventhub_auth_rule" {
  for_each = { for rule in var.authorization_rules : "${rule.eventhub_name}-${rule.name}" => rule }

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = var.resource_group_name

  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage

  depends_on = [ azurerm_eventhub.eventhubs, azurerm_eventhub_namespace.eventhub_namespace ]
}
