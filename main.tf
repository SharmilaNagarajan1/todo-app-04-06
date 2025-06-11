data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_app_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kind = "Linux"
  reserved = true
  
  sku {
    tier = "Basic"
    size = "B1"
  }
  # os_type = "Linux"
}

resource "azurerm_app_service" "frontend" {
  name                = var.frontend_app_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "NODE|18-lts"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}

resource "azurerm_app_service" "backend" {
  name                = var.backend_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

 identity {
    type = "SystemAssigned"
  }

  app_settings = {
    MONGODB_URI = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mongo_conn.id})"
  }
}

resource "azurerm_key_vault_access_policy" "backend_policy" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_access_policy" "backend_app_identity_policy" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.backend.identity[0].principal_id

  secret_permissions = ["Get"]
}


# resource "azurerm_cosmosdb_account" "mongo" {
#   name                = var.cosmosdb_account_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"

#   capabilities {
#     name = "EnableMongo"
#   }

#   consistency_policy {
#     consistency_level = "Session"
#   }

#   geo_location {
#     location          = data.azurerm_resource_group.rg.location
#     failover_priority = 0
#   }

#   # enable_automatic_failover     = true
#   public_network_access_enabled = true
# }

resource "azurerm_key_vault" "main" {
  name                        = "todoappkeyvault"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_deployment      = true
  enabled_for_template_deployment = true
  enabled_for_disk_encryption = true
}


resource "azurerm_key_vault_secret" "mongo_conn" {
  name         = "MongoDbConnString"
  value        = var.mongo_atlas_connection_string
  key_vault_id = azurerm_key_vault.main.id

  # depends_on = [azurerm_cosmosdb_account.mongo]
}


# resource "azurerm_cosmosdb_mongo_database" "todo_db" {
#   name                = var.cosmosdb_db_name
#   resource_group_name = data.azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.mongo.name
# }




