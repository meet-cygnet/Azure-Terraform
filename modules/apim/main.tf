resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name # Must be Premium for VNet integration
  tags = var.tags
  public_network_access_enabled = var.public_network_access_enabled
  identity {
    type = var.identity_type
  }
  virtual_network_type = var.virtual_network_type
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
  # dynamic "virtual_network_configuration" {
  #   for_each = var.virtual_network_configuration != null ? [1] : []
  #   content {
  #     subnet_id = var.virtual_network_configuration.subnet_id
  #   }
  # }
}
