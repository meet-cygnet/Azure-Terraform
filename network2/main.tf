######################### resource group module ############
module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

####################### Vnet module ###################

module vnet {
  source              = "../modules/vnet"
  vnet_name           = var.vnet_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  vnet_address_space  = var.vnet_address_space
  tags                = var.tags
  depends_on = [ module.resource_group ]
}

####################### Subnet modules ###################

module subnet_aks {
  source              = "../modules/subnet"
  subnet_name         = "aks-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["aks"]
  depends_on = [module.vnet]
}

module subnet_reserved {
  source              = "../modules/subnet"
  subnet_name         = "reserved-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["reserved"]
  depends_on = [module.vnet]
}

module subnet_app_gw {
  source              = "../modules/subnet"
  subnet_name         = "app-gw-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["app_gw"]
  depends_on = [module.vnet]
}

module subnet_redis {
  source              = "../modules/subnet"
  subnet_name         = "redis-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["redis"]
  depends_on = [module.vnet]
}

module subnet_bastion {
  source              = "../modules/subnet"
  subnet_name         = "bastion-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["bastion"]
  depends_on = [module.vnet]
}

module subnet_endpoints {
  source              = "../modules/subnet"
  subnet_name         = "endpoints-subnet"
  resource_group_name = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix["endpoints"]
  # enable_delegation   = var.enable_delegation
  # delegation_service_name = var.delegation_service_name
  depends_on = [module.vnet]
}

# module subnet_postgres {
#   source              = "../modules/subnet"
#   subnet_name         = "postgres-subnet"
#   resource_group_name = module.resource_group.resource_group_name
#   virtual_network_name = var.vnet_name
#   subnet_address_prefix = var.subnet_address_prefix["postgres"]
#   # enable_delegation   = var.enable_delegation
#   # delegation_service_name = var.delegation_service_name
#   depends_on = [module.vnet]
# }

resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_address_prefix["postgres"]]
  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
  depends_on           = [module.vnet]
}

####################### nsg module ###################
module "nsg_aks" {
  source              = "../modules/nsg"
  nsg_name            = "aks-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_aks.subnet_id
  tags                = var.tags
  # security_rules      = var.aks_security_rules

  depends_on = [module.subnet_aks]
}

module "nsg_reserved" {
  source              = "../modules/nsg"
  nsg_name            = "reserved-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_reserved.subnet_id
  tags                = var.tags

  depends_on = [module.subnet_reserved]
}

module "nsg_app_gw" {
  source              = "../modules/nsg"
  nsg_name            = "app-gw-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_app_gw.subnet_id
  tags                = var.tags

  depends_on = [module.subnet_app_gw]
}

module "nsg_redis" {
  source              = "../modules/nsg"
  nsg_name            = "redis-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_redis.subnet_id
  tags                = var.tags

  depends_on = [module.subnet_redis]
}

module "nsg_bastion" {
  source              = "../modules/nsg"
  nsg_name            = "bastion-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_bastion.subnet_id
  tags                = var.tags
  security_rules      = var.vm_security_rules

  depends_on = [module.subnet_bastion]
}

module "nsg_endpoints" {
  source              = "../modules/nsg"
  nsg_name            = "endpoints-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.subnet_endpoints.subnet_id
  tags                = var.tags

  depends_on = [module.subnet_endpoints]
}

module "nsg_postgres" {
  source              = "../modules/nsg"
  nsg_name            = "postgres-nsg"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = azurerm_subnet.postgres_subnet.id
  tags                = var.tags

  depends_on = [azurerm_subnet.postgres_subnet]
}
######################## Linux VM Module #########################################

module "vm_linux" {
  source               = "../modules/vm"
  vm_name              = var.linux_vm_name
  location             = var.location
  resource_group_name  = module.resource_group.resource_group_name
  vm_size              = var.linux_vm_size
  admin_username       = var.linux_vm_admin_username
  os_type              = var.linux_vm_os_type
  use_existing_ssh_key = var.linux_vm_use_existing_ssh_key
  vm_version           = var.linux_vm_version
  vm_sku               = var.linux_vm_sku
  vm_publisher         = var.linux_vm_publisher
  vm_offer             = var.linux_vm_offer
  tags                 = var.tags
  enable_public_ip     = var.enable_public_ip # Set to true if you want to enable public IP
  subnet_id            = module.subnet_bastion.subnet_id # Reference to the subnet ID
}

############## aks resources ##########################################
resource "azurerm_public_ip" "aks_nat_ip" {
  name                = "${var.aks_cluster_name}-nat-ip"
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
  depends_on = [module.vnet]
}

resource "azurerm_nat_gateway" "aks_nat_gw" {

  name                = "${var.aks_cluster_name}-nat-gw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = var.tags

  depends_on = [azurerm_public_ip.aks_nat_ip]
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

# module "aks_udr_route_table" {
#   source              = "../modules/route_table"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   subnet_id       = module.subnet_aks.subnet_id
#   route_table_name = var.aks_route_table_name
#   routes = [
#     {
#       name                   = "route-vnet1"
#       address_prefix         =  module.vnet.vnet_address_space[0]
#       next_hop_type          = "VnetLocal"
#     },
#     {
#       name                   = "route-vnet2"
#       address_prefix         = module.vnet.vnet_address_space[1]
#       next_hop_type          = "VnetLocal"
#     }
#     # {
#     #   name                   = "route-vm"
#     #   address_prefix         = "0.0.0.0/0"
#     #   next_hop_type          = "VirtualAppliance"
#     #   next_hop_in_ip_address = module.vm_linux.vm_private_ip
#     # }
#   ]

#   tags = var.tags
#   depends_on = [module.subnet_aks]
# }

################################################################
##################################################################

# resource "azurerm_role_assignment" "agic_permission" {
#   scope                = module.app_gateway.ag_id
#   role_definition_name = "Contributor"
#   principal_id         = module.app_gateway.identity_principal_id

#   depends_on = [module.app_gateway]
# }

# module "app_gateway" {
#   source = "../modules/app_gateway"

#   ag_name             = var.ag_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   ag_subnet_id        = module.subnet_app_gw.subnet_id
#   ag_sku_name         = var.ag_sku_name
#   ag_sku_tier         = var.ag_sku_tier
#   ag_capacity         = var.ag_capacity
#   # user_assigned_identity_id = module.identity.identity_id

#   tags = var.tags

#   # depends_on = [module.aks]
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