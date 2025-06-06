output "rg-name" {
  value = data.azurerm_resource_group.rg.name
}

output "frontend_app_url" {
  value = azurerm_app_service.frontend.default_site_hostname
}

output "backend_app_url" {
  value = azurerm_app_service.backend.default_site_hostname
}
