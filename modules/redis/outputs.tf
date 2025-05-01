output "redis_id" {
  description = "The ID of the Redis instance"
  value       = azurerm_redis_cache.redis.id
}

output "redis_hostname" {
  description = "The Hostname of the Redis instance"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_ssl_port" {
  description = "The SSL Port of the Redis instance"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "redis_port" {
  description = "The non-SSL Port of the Redis instance"
  value       = azurerm_redis_cache.redis.port
}

output "redis_primary_access_key" {
  description = "The Primary Access Key for the Redis instance"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "redis_secondary_access_key" {
  description = "The Secondary Access Key for the Redis instance"
  value       = azurerm_redis_cache.redis.secondary_access_key
  sensitive   = true
}

output "redis_primary_connection_string" {
  description = "The primary connection string of the Redis instance"
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
}

output "redis_secondary_connection_string" {
  description = "The secondary connection string of the Redis instance"
  value       = azurerm_redis_cache.redis.secondary_connection_string
  sensitive   = true
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.redis_private_endpoint[0].id : null
} 