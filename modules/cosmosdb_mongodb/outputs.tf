output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.id
}

output "cosmosdb_account_endpoint" {
  description = "The endpoint used to connect to the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_account_connection_strings" {
  description = "A list of connection strings available for this CosmosDB account"
  value       = azurerm_cosmosdb_account.cosmosdb.connection_strings
  sensitive   = true
}

output "cosmosdb_account_primary_master_key" {
  description = "The Primary master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_master_key
  sensitive   = true
}

output "cosmosdb_account_secondary_master_key" {
  description = "The Secondary master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.secondary_master_key
  sensitive   = true
}

output "cosmosdb_account_primary_readonly_master_key" {
  description = "The Primary read-only master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_readonly_master_key
  sensitive   = true
}

output "cosmosdb_account_secondary_readonly_master_key" {
  description = "The Secondary read-only master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.secondary_readonly_master_key
  sensitive   = true
}

output "cosmosdb_mongodb_database_id" {
  description = "The ID of the Cosmos DB MongoDB Database"
  value       = azurerm_cosmosdb_mongo_database.mongodb.id
}

output "cosmosdb_mongodb_database_name" {
  description = "The name of the Cosmos DB MongoDB Database"
  value       = azurerm_cosmosdb_mongo_database.mongodb.name
}

output "cosmosdb_mongodb_collection_ids" {
  description = "The IDs of the Cosmos DB MongoDB Collections"
  value       = [for collection in azurerm_cosmosdb_mongo_collection.collections : collection.id]
}

output "cosmosdb_mongodb_collection_names" {
  description = "The names of the Cosmos DB MongoDB Collections"
  value       = [for collection in azurerm_cosmosdb_mongo_collection.collections : collection.name]
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.cosmosdb_pe[0].id : null
} 