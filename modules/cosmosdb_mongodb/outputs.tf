output "connection_strings" {
  value = azurerm_mongo_cluster.mongo_cluster.connection_strings
}

output "mongo_cluster_id" {
  value = azurerm_mongo_cluster.mongo_cluster.id
}
