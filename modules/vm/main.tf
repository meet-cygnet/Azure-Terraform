resource "tls_private_key" "ssh" {
  count     = var.os_type == "linux" && !var.use_existing_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_size               = var.vm_size
  network_interface_ids = [azurerm_network_interface.nic.id]

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.managed_disk_type
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
  }

  dynamic "os_profile_linux_config" {
    for_each = var.os_type == "linux" ? [1] : []
    content {
      disable_password_authentication = true

      ssh_keys {
        path     = "/home/${var.admin_username}/.ssh/authorized_keys"
        key_data = var.use_existing_ssh_key ? var.existing_ssh_public_key : tls_private_key.ssh[0].public_key_openssh
      }
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = var.os_type == "windows" ? [1] : []
    content {
      winrm {
        protocol = "http"
      }

      # Windows authentication doesn't require "disable_password_authentication"
      # Just the WinRM configuration is sufficient
    }
  }

  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  tags = var.tags
}

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
