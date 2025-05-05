module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = var.vnet_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  vnet_address_space  = var.vnet_address_spaces
  tags                = var.tags

  depends_on = [module.resource_group]
}

# Subnets in first address space (10.0.0.0/16)
module "subnet_apim" {
  source                = "../modules/subnet"
  subnet_name           = "apim-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["apim"]

  depends_on = [module.vnet]
}

module "subnet_agic" {
  source                = "../modules/subnet"
  subnet_name           = "agic-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["agic"]

  depends_on = [module.vnet]
}

module "subnet_endpoints" {
  source                = "../modules/subnet"
  subnet_name           = "endpoints-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["endpoints"]

  depends_on = [module.vnet]
}

module "subnet_vm" {
  source                = "../modules/subnet"
  subnet_name           = "vm-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["vm"]

  depends_on = [module.vnet]
}

# Subnet in second address space (192.168.0.0/16)
module "subnet_aks" {
  source                = "../modules/subnet"
  subnet_name           = "aks-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["aks"]

  depends_on = [module.vnet]
}

# database subnet
module "subnet_database" {
  source                = "../modules/subnet"
  subnet_name           = "database-subnet"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = var.subnet_prefixes["database"]
  # enable_delegation       = true
  # delegation_service_name = "Microsoft.DBforPostgreSQL/flexibleServers"

  depends_on = [module.vnet]
}

# Network Security Groups
module "nsg_apim" {
  source              = "../modules/nsg"
  nsg_name            = "apim-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_apim.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_apim]
}

module "nsg_agic" {
  source              = "../modules/nsg"
  nsg_name            = "agic-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_agic.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_agic]
}

module "nsg_endpoints" {
  source              = "../modules/nsg"
  nsg_name            = "endpoints-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_endpoints.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_endpoints]
}

module "nsg_vm" {
  source              = "../modules/nsg"
  nsg_name            = "vm-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_vm.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_vm]
}

module "nsg_database" {
  source              = "../modules/nsg"
  nsg_name            = "database-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_database.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_database]
}

#### AKS  ####
resource "azurerm_public_ip" "aks_nat_ip" {
  name                = "${var.aks_cluster_name}-nat-ip"
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "aks_nat_gw" {

  name                = "${var.aks_cluster_name}-nat-gw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = var.tags

  # depends_on = [azurerm_public_ip.nat_ip]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.aks_nat_gw.id
  public_ip_address_id = azurerm_public_ip.aks_nat_ip.id
  depends_on           = [azurerm_nat_gateway.aks_nat_gw, azurerm_public_ip.aks_nat_ip]
}

resource "azurerm_subnet_nat_gateway_association" "aks_nat_assoc" {
  subnet_id      = module.subnet_aks.subnet_id
  nat_gateway_id = azurerm_nat_gateway.aks_nat_gw.id
  depends_on     = [azurerm_nat_gateway.aks_nat_gw, module.subnet_aks]
}


module "nsg_aks" {
  source              = "../modules/nsg"
  nsg_name            = "aks-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_aks.subnet_id
  tags                = var.tags

  depends_on = [module.vnet, module.subnet_aks]
}

# Route table for AKS subnet
module "route_table_aks" {
  source = "../modules/route_table"

  route_table_name    = "${var.aks_cluster_name}-aks-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.subnet_aks.subnet_id
  tags                = var.tags

  routes = {
    "vnet" = {
      address_prefix = var.vnet_address_spaces[0]
      next_hop_type  = "VnetLocal"
    }
    "vnet2" = {
      address_prefix = var.vnet_address_spaces[1]
      next_hop_type  = "VnetLocal"
    }
    "internet" = {
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }

  }

  depends_on = [module.subnet_aks]
}

# Route table for endpoints subnet
# module "route_table_endpoints" {
#   source = "../modules/route_table"

#   route_table_name    = "${var.aks_cluster_name}-endpoints-rt"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.subnet_endpoints.subnet_id
#   tags                = var.tags

#   routes = {
#     "vnet" = {
#       address_prefix = var.vnet_address_spaces[0]
#       next_hop_type  = "VnetLocal"
#     }
#     "vnet2" = {
#       address_prefix = var.vnet_address_spaces[1]
#       next_hop_type  = "VnetLocal"
#     }
#   }

#   depends_on = [module.subnet_endpoints]
# }

# Route table for VM subnet
# module "route_table_vm" {
#   source = "../modules/route_table"

#   route_table_name    = "${var.aks_cluster_name}-vm-rt"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.subnet_vm.subnet_id
#   tags                = var.tags

#   routes = {
#     "vnet" = {
#       address_prefix = var.vnet_address_spaces[0]
#       next_hop_type  = "VnetLocal"
#     }
#     "vnet2" = {
#       address_prefix = var.vnet_address_spaces[1]
#       next_hop_type  = "VnetLocal"
#     }
#   }

#   depends_on = [module.subnet_vm]
# }

# Route table for APIM subnet
# module "route_table_apim" {
#   source = "../modules/route_table"

#   route_table_name    = "${var.aks_cluster_name}-apim-rt"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.subnet_apim.subnet_id
#   tags                = var.tags

#   routes = {
#     "vnet" = {
#       address_prefix = var.vnet_address_spaces[0]
#       next_hop_type  = "VnetLocal"
#     }
#     "vnet2" = {
#       address_prefix = var.vnet_address_spaces[1]
#       next_hop_type  = "VnetLocal"
#     }
#   }

#   depends_on = [module.subnet_apim]
# }

# Route table for AGIC subnet
# module "route_table_agic" {
#   source = "../modules/route_table"

#   route_table_name    = "${var.aks_cluster_name}-agic-rt"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.subnet_agic.subnet_id
#   tags                = var.tags

#   routes = {
#     "vnet" = {
#       address_prefix = var.vnet_address_spaces[0]
#       next_hop_type  = "VnetLocal"
#     }
#     "vnet2" = {
#       address_prefix = var.vnet_address_spaces[1]
#       next_hop_type  = "VnetLocal"
#     }
#   }

#   depends_on = [module.subnet_agic]
# }

# Route table for database subnet
# module "route_table_database" {
#   source = "../modules/route_table"

#   route_table_name    = "${var.aks_cluster_name}-database-rt"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = module.subnet_database.subnet_id
#   tags                = var.tags

#   routes = {
#     "vnet" = {
#       address_prefix = var.vnet_address_spaces[0]
#       next_hop_type  = "VnetLocal"
#     }
#     "vnet2" = {
#       address_prefix = var.vnet_address_spaces[1]
#       next_hop_type  = "VnetLocal"
#     }
#   }

#   depends_on = [module.subnet_database]
# }

# module "redis" {
#   source = "../modules/redis"

#   redis_name                = "${var.aks_cluster_name}-redis"
#   location                  = var.location
#   resource_group_name       = module.resource_group.resource_group_name
#   capacity                  = 2
#   family                    = "C"
#   sku_name                  = "Standard"
#   # enable_non_ssl_port       = false
#   # minimum_tls_version       = "1.2"
#   subnet_id                 = module.subnet_endpoints.subnet_id
#   private_static_ip_address = "10.0.3.10"
#   tags                      = var.tags

#   redis_configuration = {
#     enable_authentication = true
#     maxmemory_policy      = "volatile-lru"
#   }

#   patch_schedules = [
#     {
#       day_of_week    = "Monday"
#       start_hour_utc = 2
#     }
#   ]

#   private_endpoint_enabled     = true
#   private_endpoint_subnet_id   = module.subnet_endpoints.subnet_id

#   depends_on = [module.subnet_endpoints]
# }

# resource "azurerm_role_assignment" "agic_permission" {
#   scope                = module.app_gateway.ag_id
#   role_definition_name = "Contributor"
#   principal_id         = module.app_gateway.identity_principal_id

#   depends_on = [module.app_gateway]
# }


# module "aks" {
#   source = "../modules/aks"

#   cluster_name                   = var.aks_cluster_name
#   resource_group_name            = var.resource_group_name
#   location                       = var.location
#   kubernetes_version             = var.aks_kubernetes_version
#   system_subnet_id               = module.subnet_aks.subnet_id
#   system_node_count              = var.aks_system_node_count
#   system_node_vm_size            = var.aks_system_node_vm_size
#   system_node_min_count          = var.aks_system_node_min_count
#   system_node_max_count          = var.aks_system_node_max_count
#   load_balancer_sku              = var.aks_load_balancer_sku
#   outbound_type                  = var.aks_outbound_type
#   sku_tier                       = var.aks_sku_tier
#   node_pool_os_disk_size_gb      = var.aks_node_pool_os_disk_size_gb
#   default_node_pool_os_disk_type = var.aks_default_node_pool_os_disk_type
#   node_pool_max_pods             = var.aks_node_pool_max_pods
#   default_node_pool_name         = var.aks_default_node_pool_name
#   private_cluster_enabled        = var.aks_private_cluster_enabled
#   # private_dns_zone_id            = module.aks_private_dns.private_dns_zone_id
#   # identity_id                    = module.identity.identity_id

#   tags = var.tags

#   depends_on = [module.aks_route_table]
# }

# module "app_gateway" {
#   source = "../modules/app_gateway"

#   ag_name             = var.ag_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   ag_subnet_id        = module.subnet_agic.subnet_id
#   ag_sku_name         = var.ag_sku_name
#   ag_sku_tier         = var.ag_sku_tier
#   ag_capacity         = var.ag_capacity
#   # user_assigned_identity_id = module.identity.identity_id
#   tags = var.tags

#   depends_on = [module.aks]
# }

# module "agic" {
#   source = "../modules/agic"

#   app_gateway_name    = var.ag_name
#   resource_group_name = var.resource_group_name
#   subscription_id     = var.subscription_id
#   aks_cluster_name    = var.aks_cluster_name
#   # identity_client_id            = module.identity.identity_client_id
#   verbosity_level          = var.agic_verbosity_level
#   reconcile_period_seconds = var.agic_reconcile_period_seconds
#   agic_chart_version       = var.agic_chart_version
#   namespace                = var.agic_namespace
#   service_account_name     = var.agic_service_account_name
#   # federated_identity_credential_name = "${var.aks_cluster_name}-agic-federated-credential"
#   depends_on = [azurerm_role_assignment.agic_permission]
# }

# module "acr_private_dns" {
#   source = "../modules/private_dns"

#   private_dns_zone_name = var.acr_private_dns_zone_name
#   resource_group_name   = module.resource_group.resource_group_name
#   virtual_network_id    = module.vnet.vnet_id
#   registration_enabled  = var.private_dns_registration_enabled
#   tags                  = var.tags
# }

# module "acr" {
#   source              = "../modules/acr"
#   acr_name            = var.acr_name
#   resource_group_name = module.resource_group.resource_group_name
#   location            = module.resource_group.location
#   sku                 = var.acr_sku
#   subnet_id           = module.subnet_endpoints.subnet_id
#   private_dns_zone_id = module.acr_private_dns.private_dns_zone_id
#   virtual_network_id  = module.vnet.vnet_id
#   tags                = var.tags
# }

# module "monitoring" {
#   source = "../modules/log_analytics"

#   log_analytics_workspace_name = "${var.aks_cluster_name}-law"
#   monitor_workspace_name       = "${var.aks_cluster_name}-amw"
#   location                     = module.resource_group.location
#   resource_group_name          = module.resource_group.resource_group_name
#   sku                          = "PerGB2018"
#   retention_in_days            = 30
#   tags                         = var.tags
# }

# module "identity" {
#   source = "../modules/identity"

#   identity_name       = "${var.aks_cluster_name}-identity"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   tags                = var.tags

#   role_assignments = {
#     # subscription_contributor = {
#     #   scope                = "/subscriptions/${var.subscription_id}"
#     #   role_definition_name = "Contributor"
#     # }
#     network_contributor = {
#       scope                = module.vnet.vnet_id
#       role_definition_name = "Network Contributor"
#     }
#     # app_gateway_reader = {
#     #   scope                = module.app_gateway.ag_id
#     #   role_definition_name = "Reader"
#     # }
#     resource_group_contributor = {
#       scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
#       role_definition_name = "Contributor"
#     }
#   }

#   depends_on = [module.resource_group]
# }



