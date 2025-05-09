output "vm_private_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "generated_ssh_key_file" {
  description = "Path to the generated SSH private key"
  value       = local_file.ssh_private_key[0].filename
}

# output "ssh_public_key" {
#   value = var.use_existing_ssh_key ? var.existing_ssh_public_key : tls_private_key.ssh[0].public_key_openssh
# }

# output "ssh_private_key" {
#   sensitive = true
#   value     = var.use_existing_ssh_key ? null : tls_private_key.ssh[0].private_key_pem
# }
