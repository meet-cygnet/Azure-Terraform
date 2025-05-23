resource "azurerm_route_table" "route_table" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_route" "routes" {
  for_each = { for route in var.routes : route.name => route }

  name                   = each.key
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null
}

resource "azurerm_subnet_route_table_association" "subnet_association" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.route_table.id
} 
