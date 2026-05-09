# Azure Storage Account Terraform Configuration

このフォルダには、Azure Storage Account を作成するための Terraform 設定ファイルが含まれています。

## ファイル構成

- `main.tf` - メインのリソース定義
- `variables.tf` - 変数定義
- `outputs.tf` - 出力定義
- `terraform.tfvars.template` - 設定値のテンプレート

## 使用方法

1. **設定ファイルの準備**

   ```bash
   cp terraform.tfvars.template terraform.tfvars
   ```

2. **設定値の編集**
   `terraform.tfvars`ファイルを編集して、適切な値を設定してください：

   ```hcl
   storage_account_name = "your-unique-storage-name"  # グローバルで一意な名前
   ```

3. **Terraform の初期化**

   ```bash
   terraform init
   ```

4. **プランの確認**

   ```bash
   terraform plan
   ```

5. **リソースの作成**
   ```bash
   terraform apply
   ```

## 作成されるリソース

- **Resource Group**: ストレージアカウント用のリソースグループ
- **Storage Account**: Azure Storage Account
- **Storage Containers**: 指定されたコンテナ（オプション）

## ストレージアカウントの設定

### アカウント層（Account Tier）

- `Standard`: 汎用的な用途（デフォルト）
- `Premium`: 高性能が必要な場合

### レプリケーションタイプ

- `LRS`: ローカル冗長ストレージ（デフォルト）
- `GRS`: 地理冗長ストレージ
- `RAGRS`: 読み取りアクセス地理冗長ストレージ
- `ZRS`: ゾーン冗長ストレージ
- `GZRS`: 地理ゾーン冗長ストレージ
- `RAGZRS`: 読み取りアクセス地理ゾーン冗長ストレージ

### セキュリティ設定

- HTTPS 通信のみを許可
- 最小 TLS バージョン: 1.2
- パブリックアクセスの制御

## 注意事項

1. **ストレージアカウント名**は 3-24 文字で、小文字と数字のみ使用可能です
2. ストレージアカウント名は**グローバルで一意**である必要があります
3. 作成後にストレージアカウント名を変更することはできません
4. 本番環境では適切なセキュリティ設定を行ってください

## コスト管理

- 不要なリソースは`terraform destroy`で削除してください
- ストレージアカウントのアクセス層を適切に設定してください
- 定期的に使用状況を確認してください
