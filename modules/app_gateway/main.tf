# resource "azurerm_public_ip" "ag_pip" {
#   name                = "${var.ag_name}-pip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   tags                = var.tags
# }

resource "azurerm_application_gateway" "ag" {
  name                = var.ag_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.ag_sku_name
    tier     = var.ag_sku_tier
    capacity = var.ag_capacity
  }

  gateway_ip_configuration {
    name      = "${var.ag_name}-ip-config"
    subnet_id = var.ag_subnet_id
  }

  frontend_port {
    name = "${var.ag_name}-fe-port"
    port = 80
  }

  frontend_ip_configuration {
    name                          = "${var.ag_name}-fe-ip"
    subnet_id                     = var.ag_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  backend_address_pool {
    name = "${var.ag_name}-be-pool"
  }

  backend_http_settings {
    name                  = "${var.ag_name}-be-http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${var.ag_name}-listener"
    frontend_ip_configuration_name = "${var.ag_name}-fe-ip"
    frontend_port_name             = "${var.ag_name}-fe-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.ag_name}-rule"
    rule_type                  = "Basic"
    http_listener_name         = "${var.ag_name}-listener"
    backend_address_pool_name  = "${var.ag_name}-be-pool"
    backend_http_settings_name = "${var.ag_name}-be-http"
    priority                   = 1
  }

  identity {
    type = "SystemAssigned"
    # type = "UserAssigned"
    # identity_ids = [var.user_assigned_identity_id]
  }

  tags = var.tags
} 