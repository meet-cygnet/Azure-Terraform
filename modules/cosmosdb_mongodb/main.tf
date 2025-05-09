resource "azurerm_mongo_cluster" "mongo_cluster" {
  name                   = var.cluster_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_username = var.admin_username
  administrator_password = var.admin_password

  shard_count            = var.shard_count
  compute_tier           = var.compute_tier
  high_availability_mode = var.high_availability_mode
  storage_size_in_gb     = var.storage_size_in_gb
  create_mode            = var.create_mode
  version                = var.mongodb_version

  public_network_access = var.public_network_access

  tags = var.tags
} 
