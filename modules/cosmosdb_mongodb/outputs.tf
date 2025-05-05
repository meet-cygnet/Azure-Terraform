output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongodb.id
}

output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongodb.name
}

output "cosmosdb_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.mongodb.endpoint
}

output "database_id" {
  description = "The ID of the MongoDB database"
  value       = azurerm_cosmosdb_mongo_database.db.id

}

# output "cosmosdb_connection_string" {
#   description = "The connection string for the Cosmos DB account"
#   value       = azurerm_cosmosdb_account.cosmosdb.connection_strings[0]
#   sensitive   = true
# }

# output "collection_id" {
#   description = "The ID of the MongoDB collection"
#   value       = azurerm_cosmosdb_mongo_collection.collection.id
# } 
