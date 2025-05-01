# Create subnet resource
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_address_prefix]

  dynamic "delegation" {
    for_each = var.enable_delegation ? [1] : []
    content {
      name = "delegation"

      service_delegation {
        name    = var.delegation_service_name
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

