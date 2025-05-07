output "vm_private_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "ssh_public_key" {
  value = var.use_existing_ssh_key ? var.existing_ssh_public_key : tls_private_key.ssh[0].public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = var.use_existing_ssh_key ? null : tls_private_key.ssh[0].private_key_pem
}
