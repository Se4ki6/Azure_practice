# 変数の定義
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "リソースグループの名前"
  type        = string
  default     = "rg-storage-demo"
}

variable "location" {
  description = "Azureリージョン"
  type        = string
  default     = "japaneast"
}

variable "storage_account_name" {
  description = "ストレージアカウント名（グローバルで一意である必要があります）"
  type        = string
  default     = "azuretrainingyokoyamast"
}

variable "container_name" {
  description = "Blobコンテナ名"
  type        = string
  default     = "uploads"
}

variable "local_file_path" {
  description = "アップロードするローカルファイルのパス"
  type        = string
  default     = "./sample.txt"
}

variable "blob_name" {
  description = "アップロード後のBlob名"
  type        = string
  default     = "uploaded-sample.txt"
}
