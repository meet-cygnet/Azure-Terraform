
#################### Common Data Blocks ###############################
# Data block for resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Data block for ACR
# data "azurerm_container_registry" "acr" {
#   name                = var.acr_name
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# Data blocks for VNet and subnet CIDRs
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# data "azurerm_subnet" "apim_subnet" {
#   name                 = "apim-subnet"
#   virtual_network_name = var.vnet_name
#   resource_group_name  = data.azurerm_resource_group.rg.name
# }

# data "azurerm_subnet" "agic_subnet" {
#   name                 = "agic-subnet"
#   virtual_network_name = var.vnet_name
#   resource_group_name  = data.azurerm_resource_group.rg.name
# }

data "azurerm_subnet" "endpoints_subnet" {
  name                 = "endpoints-subnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# not required for now
data "azurerm_subnet" "database_subnet" {
  name                 = "database-subnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

######################## AKS Module #########################################
# Create user-assigned identity for AKS and AGIC
# resource "azurerm_user_assigned_identity" "cluster" {
#   name                = "aks-agic-identity"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = var.location
#   tags = {
#     Environment = var.environment
#     Component   = "AKS-AGIC"
#     ManagedBy   = "terraform"
#   }
#   depends_on = [ data.azurerm_resource_group.rg ]
# }

# Create private DNS zone for AKS
module "aks_private_dns_zone" {
  source               = "../modules/private_dns_zone"
  zone_name            = "privatelink.${replace(var.location, " ", "")}.azmk8s.io"
  resource_group_name  = data.azurerm_resource_group.rg.name
  vnet_link_name       = var.vnet_link_name
  virtual_network_id   = data.azurerm_virtual_network.vnet.id
  registration_enabled = false
  tags                 = var.tags
  depends_on           = [data.azurerm_virtual_network.vnet]
}


# # Create AKS cluster in private mode
module "aks" {
  source = "../modules/aks"

  cluster_name        = var.aks_cluster_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kubernetes_version  = var.aks_kubernetes_version
  # private_dns_zone_id        = module.aks_private_dns_zone.id
  subnet_id = data.azurerm_subnet.aks_subnet.id
  # user_assigned_identity_id  = azurerm_user_assigned_identity.cluster.id

  default_node_pool_name = "systempool"

  # enable_auto_scaling   = true
  min_count = 1
  max_count = 3
  max_pods  = 30

  tags = var.tags

  depends_on = [module.aks_private_dns_zone]
}

module "aks_private_endpoint" {
  source = "../modules/private_endpoint"

  name                           = "aks-private-endpoint"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
  private_connection_resource_id = module.aks.cluster_id
  subresource_names              = ["management"]
  private_dns_zone_id            = module.aks_private_dns_zone.id
  tags                           = var.tags
  depends_on                     = [module.aks, module.aks_private_dns_zone]
}
#################################################################
#################### POSTGRESQL Module ############################################
module "postgesql_private_dns_zone" {
  source = "../modules/private_dns_zone"

  zone_name           = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_id  = data.azurerm_virtual_network.vnet.id
  vnet_link_name      = "postgresql-vnet-link"
  tags                = var.tags
  depends_on          = [data.azurerm_virtual_network.vnet]
}

module "postgresql" {
  source = "../modules/postgresql"

  name                = var.postgresql_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  admin_username      = var.postgresql_admin_username
  admin_password      = var.postgresql_admin_password # store in a secret manager in production
  sku_name            = var.postgresql_sku_name
  postgresql_version  = var.postgresql_version
  storage_mb          = 32768
  storage_tier        = var.storage_tier
  zone                = "1"
  # delegated_subnet_id   = data.azurerm_subnet.database_subnet.id
  # private_dns_zone_id   = module.postgesql_private_dns_zone.id
  backup_retention_days = var.postgresql_backup_retention_days
  geo_redundant_backup  = false
  enable_ha             = var.enable_ha
  enable_azure_ad_auth  = var.enable_azure_ad_auth
  tags                  = var.tags

  depends_on = [module.postgesql_private_dns_zone]
}

module "postgresql_private_endpoint" {
  source = "../modules/private_endpoint"

  name                           = "postgresql-private-endpoint"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
  private_connection_resource_id = module.postgresql.postgresql_server_id
  subresource_names              = ["postgresqlServer"]
  private_dns_zone_id            = module.postgesql_private_dns_zone.id
  tags                           = var.tags
  depends_on                     = [module.postgresql]
}
#########################################################################
#################### Redis Module #######################################
module "redis_private_dns_zone" {
  source = "../modules/private_dns_zone"

  zone_name           = "privatelink.redis.cache.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_id  = data.azurerm_virtual_network.vnet.id
  vnet_link_name      = "redis-vnet-link"
  tags                = var.tags
  depends_on          = [data.azurerm_virtual_network.vnet]
}

module "redis" {
  source              = "../modules/redis"
  redis_name          = var.redis_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = var.redis_sku_name
  family              = var.redis_family
  capacity            = var.redis_capacity
  redis_version       = var.redis_version
  # subnet_id            = data.azurerm_subnet.endpoints_subnet.id
  # private_static_ip_address = cidrhost(data.azurerm_subnet.endpoints_subnet.address_prefixes[0], 4)
  # shard_count = var.redis_shard_count
  # zones       = var.redis_zones


  tags       = var.tags
  depends_on = [module.redis_private_dns_zone]
}

module "redis_private_endpoint" {
  source = "../modules/private_endpoint"

  name                           = "redis-private-endpoint"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
  private_connection_resource_id = module.redis.redis_cache_id
  subresource_names              = ["redisCache"]
  private_dns_zone_id            = module.redis_private_dns_zone.id
  tags                           = var.tags
  depends_on                     = [module.redis]
}
#########################################################################
#################### APIM Module ############################################
# Create private DNS zone for APIM
# module "apim_private_dns_zone" {
#   source              = "../modules/private_dns_zone"
#   zone_name           = "privatelink.azure-api.net"
#   resource_group_name = module.resource_group.name
#   vnet_link_name      = "apim-vnet-link"
#   virtual_network_id  = module.vnet.id
#   registration_enabled = false
#   tags = {
#     Environment = var.environment
#     Component   = "APIM"
#     ManagedBy   = "terraform"
#   }
# }

# Create API Management service in internal mode
# module "apim" {
#   source = "../modules/apim"

#   name                = "dev-apim"
#   location            = var.location
#   resource_group_name = module.resource_group.name
#   publisher_name      = "Cygnet"
#   publisher_email     = "admin@cygnetinfotech.com"
#   sku_name            = "Developer_1"
#   subnet_id           = module.apim_subnet.id
#   private_dns_zone_id = module.apim_private_dns_zone.id
#   virtual_network_id = module.vnet.id
#   tags = {
#     Environment = var.environment
#     Component   = "APIM"
#     ManagedBy   = "terraform"
#   }
# }
#########################################################################
#################### AGIC Module ############################################
# Create private DNS zone for AGIC
# module "agic_private_dns_zone" {
#   source = "../modules/private_dns_zone"

#   zone_name           = "privatelink.azurewebsites.net"
#   resource_group_name = module.resource_group.name
#   virtual_network_id  = module.vnet.id
#   vnet_link_name      = "agic-vnet-link"
#   tags                = var.tags
# }

# Create Application Gateway Ingress Controller
# module "agic" {
#   source = "../modules/agic"

#   name                = "dev-agic"
#   location            = var.location
#   resource_group_name = module.resource_group.name
#   subnet_id           = module.agic_subnet.id
#   private_ip_address  = cidrhost(var.agic_subnet_prefix, 4)  # Using the 5th IP in the subnet
#   user_assigned_identity_id = azurerm_user_assigned_identity.cluster.id
#   private_dns_zone_id = module.agic_private_dns_zone.id
#   virtual_network_id  = module.vnet.id
#   tags = {
#     Environment = var.environment
#     Component   = "AGIC"
#     ManagedBy   = "terraform"
#   }
# }
#########################################################################
#################### Cosmos DB Module ###################################
# Create Cosmos DB with MongoDB API
module "cosmosdb_private_dns_zone" {
  source = "../modules/private_dns_zone"

  zone_name           = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_id  = data.azurerm_virtual_network.vnet.id
  vnet_link_name      = "cosmosdb-vnet-link"
  tags                = var.tags
  depends_on          = [data.azurerm_virtual_network.vnet]
}

module "cosmosdb" {
  source = "../modules/cosmosdb_mongodb"

  cosmosdb_name       = var.cosmosdb_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = var.offer_type
  capabilities        = var.capabilities
  geo_locations       = var.geo_locations
  backup              = var.backup
  identity_type       = var.identity_type
  database_name       = var.database_name
  # collection_name     = var.collection_name
  shard_key         = var.shard_key
  consistency_level = var.consistency_level

  indexes = [
    {
      keys   = [var.shard_key]
      unique = true
    }
  ]

  tags = var.tags
}

module "cosmosdb_private_endpoint" {
  source = "../modules/private_endpoint"

  name                           = "cosmosdb-private-endpoint"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
  private_connection_resource_id = module.cosmosdb.cosmosdb_account_id
  subresource_names              = ["MongoDB"]
  private_dns_zone_id            = module.cosmosdb_private_dns_zone.id
  tags                           = var.tags
  depends_on                     = [module.cosmosdb, module.cosmosdb_private_dns_zone]
}


#########################################################################
#################### Networking modules ############################################
# module "resource_group" {
#   source   = "../modules/resource_group"
#   name     = var.resource_group_name
#   location = var.location
# }

# module "vnet" {
#   source              = "../modules/vnet"
#   name                = var.vnet_name
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   address_space       = var.address_space
#   tags = {
#     Environment = var.environment
#   }
# }

# # Create separate NSGs for each component
# module "apim_nsg" {
#   source              = "../modules/nsg"
#   name                = "apim-nsg"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "APIM"
#   }
#   security_rules = var.nsg_rules
# }

# module "agic_nsg" {
#   source              = "../modules/nsg"
#   name                = "agic-nsg"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "AGIC"
#   }
#   security_rules = var.nsg_rules
# }

# module "database_nsg" {
#   source              = "../modules/nsg"
#   name                = "database-nsg"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "database"
#   }
#   security_rules = var.nsg_rules
# }

# module "endpoints_nsg" {
#   source              = "../modules/nsg"
#   name                = "endpoints-nsg"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "Endpoints"
#   }
#   security_rules = var.nsg_rules
# }

# module "aks_nsg" {
#   source              = "../modules/nsg"
#   name                = "aks-nsg"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "AKS"
#   }
#   security_rules = var.nsg_rules
# }

# # Create separate route tables for each component
# module "apim_route_table" {
#   source              = "../modules/route_table"
#   name                = "apim-route-table"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "APIM"
#   }
#   routes = var.route_table_routes
# }

# module "agic_route_table" {
#   source              = "../modules/route_table"
#   name                = "agic-route-table"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "AGIC"
#   }
#   routes = var.route_table_routes
# }

# module "database_route_table" {
#   source              = "../modules/route_table"
#   name                = "database-route-table"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "database"
#   }
#   routes = var.route_table_routes
# }

# module "endpoints_route_table" {
#   source              = "../modules/route_table"
#   name                = "endpoints-route-table"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "Endpoints"
#   }
#   routes = var.route_table_routes
# }

# module "aks_route_table" {
#   source              = "../modules/route_table"
#   name                = "aks-route-table"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags = {
#     Environment = var.environment
#     Component   = "AKS"
#   }
#   routes = var.route_table_routes
# }

# module "apim_subnet" {
#   source               = "../modules/subnet"
#   name                 = "apim-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   address_prefixes     = [var.apim_subnet_prefix]
# }

# module "agic_subnet" {
#   source               = "../modules/subnet"
#   name                 = "agic-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   address_prefixes     = [var.agic_subnet_prefix]
# }

# module "database_subnet" {
#   source               = "../modules/subnet"
#   name                 = "database-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   address_prefixes     = [var.database_subnet_prefix]
# }

# module "endpoints_subnet" {
#   source               = "../modules/subnet"
#   name                 = "endpoints-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   address_prefixes     = [var.endpoints_subnet_prefix]
# }

# module "aks_subnet" {
#   source               = "../modules/subnet"
#   name                 = "aks-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   address_prefixes     = [var.aks_subnet_prefix]
# }

# # Associate NSGs with their respective subnets
# resource "azurerm_subnet_network_security_group_association" "apim" {
#   subnet_id                 = module.apim_subnet.id
#   network_security_group_id = module.apim_nsg.id
#   depends_on = [ module.apim_nsg, module.apim_subnet ]
# }

# resource "azurerm_subnet_network_security_group_association" "agic" {
#   subnet_id                 = module.agic_subnet.id
#   network_security_group_id = module.agic_nsg.id
#   depends_on = [ module.agic_nsg, module.agic_subnet ]
# }

# resource "azurerm_subnet_network_security_group_association" "database" {
#   subnet_id                 = module.database_subnet.id
#   network_security_group_id = module.database_nsg.id
#   depends_on = [ module.database_nsg, module.database_subnet ]
# }

# resource "azurerm_subnet_network_security_group_association" "endpoints" {
#   subnet_id                 = module.endpoints_subnet.id
#   network_security_group_id = module.endpoints_nsg.id
#   depends_on = [ module.endpoints_nsg, module.endpoints_subnet ]
# }

# resource "azurerm_subnet_network_security_group_association" "aks" {
#   subnet_id                 = module.aks_subnet.id
#   network_security_group_id = module.aks_nsg.id
#   depends_on = [ module.aks_nsg, module.aks_subnet ]
# }

# # Associate Route Tables with their respective subnets
# resource "azurerm_subnet_route_table_association" "apim" {
#   subnet_id      = module.apim_subnet.id
#   route_table_id = module.apim_route_table.id
#   depends_on     = [module.apim_route_table, module.apim_subnet]
# }

# resource "azurerm_subnet_route_table_association" "agic" {
#   subnet_id      = module.agic_subnet.id
#   route_table_id = module.agic_route_table.id
#   depends_on     = [module.agic_route_table, module.agic_subnet]
# }

# resource "azurerm_subnet_route_table_association" "database" {
#   subnet_id      = module.database_subnet.id
#   route_table_id = module.database_route_table.id
#   depends_on     = [module.database_route_table, module.database_subnet]
# }

# resource "azurerm_subnet_route_table_association" "endpoints" {
#   subnet_id      = module.endpoints_subnet.id
#   route_table_id = module.endpoints_route_table.id
#   depends_on     = [module.endpoints_route_table, module.endpoints_subnet]
# }

# resource "azurerm_subnet_route_table_association" "aks" {
#   subnet_id      = module.aks_subnet.id
#   route_table_id = module.aks_route_table.id
#   depends_on     = [module.aks_route_table, module.aks_subnet]
# }
