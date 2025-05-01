locals {
  ha_supported = contains(["GP_", "MO_"], substr(var.sku_name, 0, 3)) && var.enable_ha
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  sku_name                      = var.sku_name
  version                       = var.postgresql_version
  storage_mb                    = var.storage_mb
  storage_tier                  = var.storage_tier
  zone                          = var.zone
  # private_dns_zone_id           = var.private_dns_zone_id
  # delegated_subnet_id           = var.delegated_subnet_id
  public_network_access_enabled = var.public_network_access_enabled
  dynamic "high_availability" {
    for_each = local.ha_supported ? [1] : []
    content {
      mode                      = var.ha_mode
    }
  }
  authentication {
    active_directory_auth_enabled = var.enable_azure_ad_auth
    password_auth_enabled         = true
  }
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup

  tags = var.tags
}
