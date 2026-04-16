# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Zmiana na wersję 3.x może pomóc, jeśli moduł był pod nią testowany,
      # ale najbezpieczniej upewnić się, że konfiguracja sieciowa jest pełna.
      version = "~> 4.1.0"
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

  # Uzupełnienie network_acls zgodnie z Twoją tabelą wymagań (Required: yes)
  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }
}
