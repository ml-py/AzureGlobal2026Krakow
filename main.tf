terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "example-resources" #change here
    storage_account_name = "tfstorage123dominik" #change here
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  # also any inputs for the module (see below)
  keyvault_name = "globazukv10"
  resource_group = {
    location = "northeurope"
    name     = "rg-user10"
  }
  network_acls = {
    bypass = "AzureService"
  }
}
