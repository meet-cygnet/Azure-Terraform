output "aks_nsg_id" {
  description = "ID of the AKS NSG"
  value       = module.nsg_aks.nsg_id
}