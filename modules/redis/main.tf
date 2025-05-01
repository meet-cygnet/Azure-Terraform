resource "azurerm_redis_cache" "redis" {
  name                      = var.redis_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  capacity                  = var.capacity
  family                    = var.family
  sku_name                  = var.sku_name
  # shard_count               = var.shard_count
  # zones                     = var.zones # this should be uncomemented for production
  tags                      = var.tags
  public_network_access_enabled = var.public_network_access_enabled

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

}

