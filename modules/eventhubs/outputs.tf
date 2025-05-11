output "namespace_id" {
  value = azurerm_eventhub_namespace.eventhub_namespace.id
}

output "eventhub_names" {
  value = [for eh in azurerm_eventhub.eventhubs: eh.name]
}
