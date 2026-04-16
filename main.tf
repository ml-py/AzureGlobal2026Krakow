# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-user10"
    storage_account_name = "user10dzis"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"

  keyvault_name = "globazukv10"

  resource_group = {
    location = "northeurope"
    name     = "rg-user10"
  }

  # Poprawiona struktura network_acls (usunięto duplikację bypass)
  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }
}

# --- SEKCJA MS SQL ---

module "mssql" {
  # Zmieniono tag na mssql/v1.1.0 - częsta wersja w tym repozytorium
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql/v1.1.0"

  sql_server_name = "sql-server-user10-globazu"
  database_name   = "db-user10"

  resource_group = {
    location = "northeurope"
    name     = "rg-user10"
  }

  administrator_login          = "sqladmin"
  administrator_login_password = "ComplexPassword123!"
}
