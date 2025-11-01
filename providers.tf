# プロバイダーの設定
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Azure プロバイダーの設定
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}