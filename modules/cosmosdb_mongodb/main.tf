locals {
  collections = var.collections
}

resource "azurerm_cosmosdb_account" "mongodb" {
  name                = var.cosmosdb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = "MongoDB"

  ip_range_filter = var.ip_range_filter

  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
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
  for_each            = var.databases
  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
  throughput          = lookup(each.value, "throughput", null)

  dynamic "autoscale_settings" {
    for_each = lookup(each.value, "autoscale_settings", null) != null ? [each.value.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "collection" {
  for_each = {
    for collection in local.collections : "${collection.database_name}.${collection.name}" => collection
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
  database_name       = each.value.database_name
  shard_key           = each.value.shard_key
  throughput          = lookup(each.value, "throughput", null)

  dynamic "autoscale_settings" {
    for_each = lookup(each.value, "autoscale_settings", null) != null ? [each.value.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  dynamic "index" {
    for_each = lookup(each.value, "indexes", [])
    content {
      keys   = index.value.keys
      unique = lookup(index.value, "unique", false)
    }
  }
}

resource "azurerm_private_endpoint" "cosmosdb_pe" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = "${var.cosmosdb_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.cosmosdb_name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mongodb.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

  tags = var.tags
}
