data "azurerm_resource_group" "rg" {
  name = "var.resource_group_name"
}

resource "azurerm_app_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku {
    tier = "Basic"
    size = "B1"
  }
  os_type = "Linux"
}

resource "azurerm_app_service" "frontend" {
  name                = var.frontend_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
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
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "NODE|18-lts"
  }

  app_settings = {
    MONGODB_URI = azurerm_cosmosdb_mongo_database.todo_db.connection_strings[0]
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}

resource "azurerm_cosmosdb_account" "mongo" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "todo_db" {
  name                = var.cosmosdb_db_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.mongo.name
}

