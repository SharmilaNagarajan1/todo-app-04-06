
variable "resource_group_name" {
  default = "kml_rg_main-8fa5e8cfbb4c493d"
}

variable "location" {
  default = "westus"
}

variable "app_service_plan_name" {
  default = "todoapp-plan123"
}

variable "frontend_app_name" {
  default = "frontendapp-100"
}

variable "backend_app_name" {
  default = "backendapp-100"
}


variable "mongo_atlas_connection_string" {
  type        = string
  description = "MongoDB Atlas connection string"
  sensitive = true
}

