################Common Variables ############
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
resource_group_name    = "TEST-RG-Prod"
location               = "centralindia"
vnet_name              = "VNet-Prod"
environment            = "Development"

############### AKS VARIABLES ###############
# vnet_link_name         = "aks-vnet-link"
# aks_subnet_name        = "aks-subnet"
# aks_cluster_name       = "dev-aks-cluster"
# aks_kubernetes_version = "1.31.7"
# aks_service_cidr       = "172.26.64.0/16" # Using the first /16 block from the address space
# aks_dns_service_ip     = "172.26.64.10"   # First available IP in the service CIDR range 


############### POSTGRESQL VARIABLES ###############
postgresql_sku_name       = "B_Standard_B1ms"
postgresql_admin_username = "postgres"
postgresql_admin_password = ""
postgresql_name           = "abc-postgresql-dev"
postgresql_version        = "16"
# postgresql_ha_mode = "SameZone"
enable_azure_ad_auth             = false
postgresql_backup_retention_days = 7
storage_tier                     = "P4"
enable_ha                        = false


#################### REDIS VARIABLES #################
redis_name                 = "abcredisdev"
redis_sku_name             = "Standard"
redis_family               = "C"
redis_capacity             = 1
redis_non_ssl_port_enabled = false
redis_minimum_tls_version  = "1.2"
redis_version              = "6"
# redis_shard_count          = 1
# redis_zones                = ["1"]


###################### COSMOSDB VARIABLES #######################
cosmosdb_name = "abc-cosmosdb-dev"
database_name = "dev-db"
backup = {
  type                 = "Periodic"
  interval_in_minutes  = 60
  retention_in_hours   = 24
}
consistency_level = "Session"
cosmosdb_kind = "Mongo"
geo_locations = [
  {
    location          = "Central India"
    failover_priority = 0
  },
  {
    location          = "South India"
    failover_priority = 1
  }
]
identity_type = "SystemAssigned"
offer_type = "Standard"
shard_key = "shardKey"


######################################################

# ad  dress_space      = [
#     "10.96.58.0/24",
#     "10.96.56.0/23",
#     "172.26.64.0/24"
# ]

# # Subnet address prefixes
# apim_subnet_prefix     = "10.96.58.0/26"     # Using first /26 from 10.96.58.0/24
# agic_subnet_prefix     = "10.96.58.64/26"    # Using second /26 from 10.96.58.0/24
# reserved_subnet_prefix = "10.96.58.128/26"   # Using third /26 from 10.96.58.0/24
# endpoints_subnet_prefix = "10.96.56.0/24"    # Using first /24 from 10.96.56.0/23
# aks_subnet_prefix      = "172.26.64.0/24"    # Using the entire 172.26.64.0/24 space

# NSG configuration
# nsg_name = "dev-nsg"

# Route Table configuration
# route_table_name = "dev-route-table"

############################################################