terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.53.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  backend "azurerm" {
    # resource_group_name  = "rg-terraform-state-dev"
    # storage_account_name = "st422y5xu5ny"
    # container_name       = "tfstate"
    # key                  = "observability-dev"
  }
}

provider "azurerm" {
  features {}
}
