variable "resource_group_name" {
  default = "kml_rg_main-79ab99031ac846af"
}

variable "location" {
  default = "westus"
}

variable "app_service_plan_name" {
  default = "todoapp-plan"
}

variable "frontend_app_name" {
  default = "todo-frontend-app"
}

variable "backend_app_name" {
  default = "todo-backend-app"
}

variable "cosmosdb_account_name" {
  default = "todocosmosaccount"
}

variable "cosmosdb_db_name" {
  default = "tododb"
}
