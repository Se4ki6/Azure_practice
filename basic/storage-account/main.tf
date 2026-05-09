# Azure Storage Account Configuration

# Resource Group
resource "azurerm_resource_group" "storage_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind            = var.account_kind

  # Security settings
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  
  # HTTPS traffic only
  enable_https_traffic_only = true

  # Minimum TLS version
  min_tls_version = "TLS1_2"

  # Network access
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# Storage Container (Optional)
resource "azurerm_storage_container" "container" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.containers[count.index].access_type
}