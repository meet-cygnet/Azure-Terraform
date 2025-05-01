# resource "azurerm_role_assignment" "acr_pull" {
#   scope                = var.acr_id
#   role_definition_name = "AcrPull"
#   principal_id         = var.client_id
# }

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  outbound_type       = var.outbound_type

  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    os_disk_size_gb     = var.node_pool_os_disk_size_gb
    os_disk_type        = var.default_node_pool_os_disk_type
    max_pods            = var.node_pool_max_pods
    vnet_subnet_id      = var.system_subnet_id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.system_node_min_count
    max_count           = var.system_node_max_count
  }

  identity {
    type = "SystemAssigned"
    # type         = "UserAssigned"
    # identity_ids = [var.identity_id]
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = var.load_balancer_sku
    outbound_type     = var.outbound_type
  }

  private_cluster_enabled = var.private_cluster_enabled
  # private_dns_zone_id     = var.private_dns_zone_id

  sku_tier = var.sku_tier

  tags = var.tags
}

# resource "azurerm_kubernetes_cluster_node_pool" "user" {
#   name                  = "user"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size               = var.user_node_vm_size
#   node_count            = var.user_node_count
#   vnet_subnet_id        = var.user_subnet_id
#   min_count             = var.user_node_min_count
#   max_count             = var.user_node_max_count
#   os_disk_size_gb       = var.node_pool_os_disk_size_gb
#   max_pods              = var.node_pool_max_pods

#   tags = var.tags
# }

