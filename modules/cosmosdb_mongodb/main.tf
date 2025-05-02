 resource "azurerm_cosmosdb_account" "mongodb" {
  name                = var.cosmosdb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.cosmosdb_kind
  # ip_range_filter = var.ip_range_filter
 
  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }
 
  capabilities {
    name = "EnableMongo"
  }
 
  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }
 
  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = backup.value.type
      interval_in_minutes = lookup(backup.value, "interval_in_minutes", null)
      retention_in_hours  = lookup(backup.value, "retention_in_hours", null)
    }
  }
 
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type = var.identity_type
    }
  }
 
  tags = var.tags
}
 
resource "azurerm_cosmosdb_mongo_database" "db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
 
  autoscale_settings{
      max_throughput = var.max_throughput
  }
}
 
 
 
