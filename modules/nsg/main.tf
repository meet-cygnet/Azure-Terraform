resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                           = security_rule.value.name
      priority                       = security_rule.value.priority
      direction                      = security_rule.value.direction
      access                         = security_rule.value.access
      protocol                       = security_rule.value.protocol
      source_port_range              = lookup(security_rule.value, "source_port_range", null)
      destination_port_range         = lookup(security_rule.value, "destination_port_range", null)
      source_port_ranges             = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_ranges        = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix          = lookup(security_rule.value, "source_address_prefix", null)
      destination_address_prefix     = lookup(security_rule.value, "destination_address_prefix", null)
      source_address_prefixes        = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefixes   = lookup(security_rule.value, "destination_address_prefixes", null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
