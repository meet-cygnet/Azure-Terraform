output "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.id
}

output "private_dns_zone_name" {
  description = "The name of the Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.name
} 