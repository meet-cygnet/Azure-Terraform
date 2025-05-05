resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name

  tags = var.tags

  identity {
    type = var.identity_type
  }

  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_configuration != null ? [1] : []
    content {
      subnet_id = var.virtual_network_configuration.subnet_id
    }
  }

  public_ip_address_id = var.public_ip_address_id
}
