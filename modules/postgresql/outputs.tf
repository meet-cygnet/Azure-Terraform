output "postgresql_server_fqdn" {
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
  description = "FQDN of the PostgreSQL server"
}

output "postgresql_server_id" {
  value       = azurerm_postgresql_flexible_server.postgres.id
  description = "ID of the PostgreSQL server"
}
