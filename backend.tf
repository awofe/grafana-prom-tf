terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "cloudmorestorage"
    container_name       = "tfstate"
    key                  = "cloudmoredeploy.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}


provider "azurerm" {
  alias           = "assessment"
  subscription_id = "372a7161-55e8-4955-8ad9-64896b021cd2"
  features {}
}
