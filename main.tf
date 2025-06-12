data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
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


resource "azurerm_key_vault" "main" {
  name                        = "todoappkeyvault-${random_string.suffix.result}"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
 
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }
}


resource "azurerm_key_vault_secret" "mongo_conn" {
  name         = "MongoDbConnString"
  value        = var.mongo_atlas_connection_string
  key_vault_id = azurerm_key_vault.main.id


}





