variable "resource_group_name" {
  default = "kml_rg_main-a0480e4f5ac140f8"
}

variable "location" {
  default = "westus"
}

variable "app_service_plan_name" {
  default = "todoapp-plan123"
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

variable "mongo_atlas_connection_string" {
  type        = string
  description = "MongoDB Atlas connection string"
  sensitive = true
}
