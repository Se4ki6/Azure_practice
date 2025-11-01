# リソースグループの作成
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Purpose     = "StorageAccount"
  }
}

# ストレージアカウントの作成
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  # パブリックアクセスの設定
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true

  tags = {
    environment = "demo"
  }
}

# Blobコンテナの作成
resource "azurerm_storage_container" "main" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# ローカルファイルをBlobストレージにアップロード
resource "azurerm_storage_blob" "main" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = var.local_file_path
  content_md5            = filemd5(var.local_file_path)
}
