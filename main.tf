terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Zmiana na wersję 3.x może pomóc, jeśli moduł był pod nią testowany,
      # ale najbezpieczniej upewnić się, że konfiguracja sieciowa jest pełna.
      version = ">= 4.1.0"
    #  version = "=4.1.0"
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
  # also any inputs for the module (see below)
  keyvault_name = "globazukv10"

  resource_group = {
    location = "northeurope"
    name     = "rg-user10"
  }

  # Poprawione: usunięto duplikaty i dodano wymagane pola z Twojej specyfikacji
  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }
}

# --- MODUŁ MS SQL ---

module "mssql" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql/v1.0.0"

  # Unikalna nazwa serwera (musi być unikalna w skali Azure)
  sql_server_name = "sql-server-user10-globazu"
  database_name   = "db-user10"

  resource_group = {
    location = "northeurope"
    name     = "rg-user10"
  }

  # Poświadczenia administratora
  administrator_login          = "sqladmin"
  administrator_login_password = "Password12345!" # Pamiętaj o wymogach złożoności Azure
}
