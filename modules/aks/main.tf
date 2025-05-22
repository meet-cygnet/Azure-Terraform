resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix         = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  
  private_cluster_enabled = true
  private_dns_zone_id    = var.private_dns_zone_id
  
  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_node_count
    vm_size             = var.default_node_pool_vm_size
    os_disk_size_gb     = var.default_node_pool_os_disk_size_gb
    vnet_subnet_id      = var.subnet_id
    auto_scaling_enabled = var.enable_auto_scaling
    min_count           = var.min_count
    max_count           = var.max_count
    max_pods            = var.max_pods
  }

  network_profile {
    network_plugin     = "azure"
    # outbound_type = var.outbound_type
    # service_cidr       = var.service_cidr
    # dns_service_ip     = var.dns_service_ip
  }

  # identity {
  #   type         = "SystemAssigned"
  #   # identity_ids = [var.user_assigned_identity_id]
  # }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = var.tags
} 