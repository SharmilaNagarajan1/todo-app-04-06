resource "azurerm_linux_web_app" "webapp2" {
  name                = "backend-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.service-plan.id

  site_config {}
}
