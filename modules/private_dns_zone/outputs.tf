output "id" {
  description = "The ID of the Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.id
}

output "name" {
  description = "The name of the Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.name
}

output "number_of_record_sets" {
  description = "The current number of record sets in this Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.number_of_record_sets
}

output "max_number_of_record_sets" {
  description = "The maximum number of record sets that can be created in this Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.max_number_of_record_sets
}

output "max_number_of_virtual_network_links" {
  description = "The maximum number of virtual networks that can be linked to this Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.max_number_of_virtual_network_links
}

output "max_number_of_virtual_network_links_with_registration" {
  description = "The maximum number of virtual networks that can be linked to this Private DNS Zone with registration enabled"
  value       = azurerm_private_dns_zone.dns_zone.max_number_of_virtual_network_links_with_registration
} 