# 出力値の定義
output "resource_group_name" {
  description = "作成されたリソースグループの名前"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "作成されたストレージアカウントの名前"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_key" {
  description = "ストレージアカウントのプライマリキー"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_account_connection_string" {
  description = "ストレージアカウントの接続文字列"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "blob_url" {
  description = "アップロードされたBlobのURL"
  value       = azurerm_storage_blob.main.url
}

output "container_name" {
  description = "作成されたコンテナの名前"
  value       = azurerm_storage_container.main.name
}