output "redis_hostname" {
  value       = azurerm_redis_cache.redis.hostname
  description = "The Redis hostname"
}

output "redis_primary_access_key" {
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
  description = "The Redis primary access key"
}

output "redis_cache_id" {
  value       = azurerm_redis_cache.redis.id
  description = "The Redis ID"
}