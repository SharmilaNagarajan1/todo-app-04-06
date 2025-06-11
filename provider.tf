terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.10.0"
    }
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  # skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  resource_provider_registrations = "none"
  features {}

}