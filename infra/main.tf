
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

# data "azurerm_subnet" "aks_subnet" {
#   name                 = var.aks_subnet_name
#   virtual_network_name = var.vnet_name
#   resource_group_name  = data.azurerm_resource_group.rg.name
# }

data "azurerm_subnet" "apim_subnet" {
  name                 = "apim-subnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

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


data "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

######################## Linux VM Module #########################################

module "vm_linux" {
  source               = "../modules/vm"
  vm_name              = var.linux_vm_name
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
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
  subnet_id            = data.azurerm_subnet.vm_subnet.id
}


######################## Windows VM Module #########################################
# module "vm_windows" {
#   source               = "../modules/vm"  # Path to the VM module
#   vm_name              = "windows-vm-test"
#   location             = "East US"
#   resource_group_name  = "my-resource-group"
#   vm_size              = "Standard_B2s"
#   admin_username       = "azureuser"
#   os_type              = "windows"  # Specify OS type as windows
#   use_existing_ssh_key = false  # Set to true if you want to use an existing key, false to generate new one
#   vm_version           = "latest"  # Specify the VM version
#   vm_sku               = "sku-name"  # Specify the VM SKU
#   vm_publisher         = "MicrosoftWindowsServer"  # Specify the VM publisher
#   vm_offer             = "WindowsServer"  # Specify the VM offer
#   tags                 = var.tags
#   subnet_id            = module.subnet_aks.subnet_id  # Reference to the subnet ID
# }

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
# module "aks_private_dns_zone" {
#   source              = "../modules/private_dns_zone"
#   zone_name           = "privatelink.${replace(var.location, " ", "")}.azmk8s.io"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   vnet_link_name      = var.vnet_link_name
#   virtual_network_id  = data.azurerm_virtual_network.vnet.id
#   tags                = var.tags
#   depends_on          = [data.azurerm_virtual_network.vnet]
# }


# # Create AKS cluster in private mode
# module "aks" {
#   source = "../modules/aks"

#   cluster_name        = var.aks_cluster_name
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   kubernetes_version  = var.aks_kubernetes_version
#   # private_dns_zone_id        = module.aks_private_dns_zone.id
#   subnet_id = data.azurerm_subnet.aks_subnet.id
#   # user_assigned_identity_id  = azurerm_user_assigned_identity.cluster.id

#   default_node_pool_name = "systempool"

#   # enable_auto_scaling   = true
#   min_count = 1
#   max_count = 3
#   max_pods  = 30

#   tags = var.tags

#   depends_on = [module.aks_private_dns_zone]
# }

# module "aks_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "aks-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.aks.cluster_id
#   subresource_names              = ["management"]
#   private_dns_zone_id            = module.aks_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.aks, module.aks_private_dns_zone]
# }

#################### POSTGRESQL Module ############################################
# module "postgesql_private_dns_zone" {
#   source = "../modules/private_dns_zone"

#   zone_name           = "privatelink.postgres.database.azure.com"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   virtual_network_id  = data.azurerm_virtual_network.vnet.id
#   vnet_link_name      = "postgresql-vnet-link"
#   tags                = var.tags
#   depends_on          = [data.azurerm_virtual_network.vnet]
# }

# module "postgresql" {
#   source = "../modules/postgresql"

#   name                = var.postgresql_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   admin_username      = var.postgresql_admin_username
#   admin_password      = var.postgresql_admin_password # store in a secret manager in production
#   sku_name            = var.postgresql_sku_name
#   postgresql_version  = var.postgresql_version
#   storage_mb          = 32768
#   storage_tier        = var.storage_tier
#   zone                = "1"
#   # delegated_subnet_id   = data.azurerm_subnet.database_subnet.id
#   # private_dns_zone_id   = module.postgesql_private_dns_zone.id
#   backup_retention_days = var.postgresql_backup_retention_days
#   geo_redundant_backup  = false
#   enable_ha             = var.enable_ha
#   enable_azure_ad_auth  = var.enable_azure_ad_auth
#   tags                  = var.tags

#   depends_on = [module.postgesql_private_dns_zone]
# }

# module "postgresql_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "postgresql-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.postgresql.postgresql_server_id
#   subresource_names              = ["postgresqlServer"]
#   private_dns_zone_id            = module.postgesql_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.postgresql]
# }

#################### Redis Module #######################################
# module "redis_private_dns_zone" {
#   source = "../modules/private_dns_zone"

#   zone_name           = "privatelink.redis.cache.windows.net"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   virtual_network_id  = data.azurerm_virtual_network.vnet.id
#   vnet_link_name      = "redis-vnet-link"
#   tags                = var.tags
#   depends_on          = [data.azurerm_virtual_network.vnet]
# }

# module "redis" {
#   source              = "../modules/redis"
#   redis_name          = var.redis_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku_name            = var.redis_sku_name
#   family              = var.redis_family
#   capacity            = var.redis_capacity
#   redis_version       = var.redis_version
#   # subnet_id            = data.azurerm_subnet.endpoints_subnet.id
#   # private_static_ip_address = cidrhost(data.azurerm_subnet.endpoints_subnet.address_prefixes[0], 4)
#   # shard_count = var.redis_shard_count
#   # zones       = var.redis_zones


#   tags       = var.tags
#   depends_on = [module.redis_private_dns_zone]
# }

# module "redis_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "redis-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.redis.redis_cache_id
#   subresource_names              = ["redisCache"]
#   private_dns_zone_id            = module.redis_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.redis]
# }

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

#   name                = var.apim_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   publisher_name      = var.apim_publisher_name
#   publisher_email     = var.apim_publisher_email
#   sku_name            = var.apim_sku_name
#   subnet_id           = data.azurerm_subnet.apim_subnet.id
#   # private_dns_zone_id = module.apim_private_dns_zone.id
#   # virtual_network_id = module.vnet.id
#   tags = var.tags
# }

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

#################### Cosmos DB Module ###################################
# Create Cosmos DB with MongoDB API
# module "cosmosdb_private_dns_zone" {
#   source = "../modules/private_dns_zone"

#   zone_name           = "privatelink.mongocluster.cosmos.azure.com"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   virtual_network_id  = data.azurerm_virtual_network.vnet.id
#   vnet_link_name      = "cosmosdb-vnet-link"
#   tags                = var.tags
#   depends_on          = [data.azurerm_virtual_network.vnet]
# }

# module "cosmosdb" {
#   source = "../modules/cosmosdb_mongodb"

#   resource_group_name    = data.azurerm_resource_group.rg.name
#   location               = data.azurerm_resource_group.rg.location
#   cluster_name           = var.cosmosdb_cluster_name
#   mongodb_version        = var.mongo_version
#   admin_username         = var.cosmosdb_admin_username
#   admin_password         = var.cosmosdb_admin_password # store in a secret manager in production
#   shard_count            = var.cosmosdb_shard_count
#   compute_tier           = var.cosmosdb_compute_tier
#   high_availability_mode = var.cosmosdb_high_availability_mode
#   storage_size_in_gb     = var.cosmosdb_storage_size_in_gb
#   public_network_access  = var.cosmosdb_public_network_access
#   tags                   = var.tags

# }

# module "cosmosdb_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "cosmosdb-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.cosmosdb.mongo_cluster_id
#   subresource_names              = ["mongoCluster"]
#   private_dns_zone_id            = module.cosmosdb_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.cosmosdb, module.cosmosdb_private_dns_zone]
# }

#########################################################################
#################### Storage Account Module ############################################
# module "storage_account_private_dns_zone" {
#   source               = "../modules/private_dns_zone"
#   zone_name            = "privatelink.blob.core.windows.net"
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   vnet_link_name       = "storage-account-vnet-link"
#   virtual_network_id   = data.azurerm_virtual_network.vnet.id
#   tags                 = var.tags
#   depends_on           = [data.azurerm_virtual_network.vnet]
# }

# module "storage_account" {
#   source                 = "../modules/storage_account"
#   name                   = var.storage_account_name
#   resource_group_name    = data.azurerm_resource_group.rg.name
#   location               = data.azurerm_resource_group.rg.location
#   account_tier           = "Standard"
#   account_replication_type = "LRS"
#   tags = var.tags
# }

# module "storage_account_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "storage-account-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.storage_account.storage_account_id
#   subresource_names              = ["blob"]
#   private_dns_zone_id            = module.storage_account_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.storage_account, module.storage_account_private_dns_zone]
# }

######################### Event Hub Module ############################################
# module "eventhub_private_dns_zone" {
#   source              = "../modules/private_dns_zone"
#   zone_name           = "privatelink.servicebus.windows.net"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   vnet_link_name      = "eventhub-vnet-link"
#   virtual_network_id  = data.azurerm_virtual_network.vnet.id
#   tags                = var.tags
#   depends_on          = [data.azurerm_virtual_network.vnet]
# }


# module "private_eventhub" {
#   source                  = "../modules/eventhubs"
#   resource_group_name     = data.azurerm_resource_group.rg.name
#   location                = var.location
#   eventhub_sku            = var.eventhub_sku
#   eventhub_namespace_name = var.eventhub_namespace_name
#   processing_units        = var.processing_units
#   subnet_id               = data.azurerm_subnet.endpoints_subnet.id

#   eventhubs = [
#     {
#       name              = "stream1"
#       partition_count   = 4
#       message_retention = 7
#     }
#   ]

#   authorization_rules = [
#     {
#       name          = "send-read"
#       eventhub_name = "stream1"
#       listen        = true
#       send          = true
#       manage        = false
#     }
#   ]

#   tags       = var.tags
#   depends_on = [data.azurerm_virtual_network.vnet]
# }


# module "event_hub_private_endpoint" {
#   source = "../modules/private_endpoint"

#   name                           = "eventhub-private-endpoint"
#   location                       = data.azurerm_resource_group.rg.location
#   resource_group_name            = data.azurerm_resource_group.rg.name
#   private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
#   private_connection_resource_id = module.private_eventhub.namespace_id
#   subresource_names              = ["namespace"]
#   private_dns_zone_id            = module.eventhub_private_dns_zone.id
#   tags                           = var.tags
#   depends_on                     = [module.private_eventhub, module.eventhub_private_dns_zone]
# }

######################### Service Bus Module ############################################

module "servicebus_private_dns_zone" {
  source              = "../modules/private_dns_zone"
  zone_name           = "privatelink.servicebus.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_link_name      = "servicebus-vnet-link"
  virtual_network_id  = data.azurerm_virtual_network.vnet.id
  tags                = var.tags
  depends_on          = [data.azurerm_virtual_network.vnet]
}

module "private_servicebus" {
  source              = "../modules/servicebus"
  namespace_name      = var.servicebus_namespace_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  enable_queue        = var.enable_queue
  sku                 = var.servicebus_sku
  queue_name          = var.servicebus_queue_name
  tags                = var.tags
}

module "servicebus_private_endpoint" {
  source = "../modules/private_endpoint"

  name                           = "servicebus-private-endpoint"
  location                       = data.azurerm_resource_group.rg.location
  resource_group_name            = data.azurerm_resource_group.rg.name
  private_endpoint_subnet_id     = data.azurerm_subnet.endpoints_subnet.id
  private_connection_resource_id = module.private_servicebus.servicebus_namespace_id
  subresource_names              = ["namespace"]
  private_dns_zone_id            = module.servicebus_private_dns_zone.id
  tags                           = var.tags
  depends_on                     = [module.private_servicebus, module.servicebus_private_dns_zone]
}

###########################################################################################
