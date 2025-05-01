resource "azurerm_redis_cache" "redis" {
  name                      = var.redis_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  capacity                  = var.capacity
  family                    = var.family
  sku_name                  = var.sku_name
  subnet_id                 = var.subnet_id
  private_static_ip_address = var.private_static_ip_address
  shard_count               = var.shard_count
  zones                     = var.zones
  tags                      = var.tags

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      maxmemory_policy                = lookup(redis_configuration.value, "maxmemory_policy", "volatile-lru")
      notify_keyspace_events          = lookup(redis_configuration.value, "notify_keyspace_events", "")
      maxmemory_reserved              = lookup(redis_configuration.value, "maxmemory_reserved", null)
      maxmemory_delta                 = lookup(redis_configuration.value, "maxmemory_delta", null)
      maxfragmentationmemory_reserved = lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null)
      rdb_backup_enabled              = lookup(redis_configuration.value, "rdb_backup_enabled", false)
      rdb_backup_frequency            = lookup(redis_configuration.value, "rdb_backup_frequency", null)
      rdb_backup_max_snapshot_count   = lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null)
      rdb_storage_connection_string   = lookup(redis_configuration.value, "rdb_storage_connection_string", null)
    }
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedules != null ? var.patch_schedules : []
    content {
      day_of_week    = patch_schedule.value.day_of_week
      start_hour_utc = patch_schedule.value.start_hour_utc
    }
  }
}

resource "azurerm_private_endpoint" "redis_private_endpoint" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = "${var.redis_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.redis_name}-psc"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  tags = var.tags
} 
