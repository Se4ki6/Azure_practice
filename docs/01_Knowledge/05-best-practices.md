# 注意事項とベストプラクティス

Terraform を使用した Azure 環境の構築・運用において、セキュリティ、コスト、保守性の観点から重要な注意事項とベストプラクティスを説明します。

## 🔒 セキュリティのベストプラクティス

### 1. 機密情報の管理

#### terraform.tfvars の扱い

```gitignore
# .gitignore に必ず追加
*.tfvars
*.tfvars.json
terraform.tfstate*
.terraform/
.terraform.lock.hcl
```

**理由**:

- `terraform.tfvars`にはサブスクリプション ID などの機密情報が含まれる
- 状態ファイルにはリソースの詳細情報が含まれる
- これらが GitHub などで公開されると重大なセキュリティリスク

#### 環境変数の活用

```powershell
# 機密情報を環境変数で設定
$env:TF_VAR_subscription_id = "your-subscription-id"

# Terraformが自動的に環境変数を読み込む
terraform plan
```

#### Azure Key Vault との連携

```hcl
# より高度な機密情報管理
data "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-key"
  key_vault_id = azurerm_key_vault.main.id
}
```

### 2. アクセス制御

#### 最小権限の原則

```hcl
# リソースのアクセス制御
resource "azurerm_storage_container" "main" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"  # publicは避ける
}
```

#### ネットワークアクセス制限

```hcl
resource "azurerm_storage_account" "main" {
  # ... 他の設定

  network_rules {
    default_action = "Deny"
    ip_rules       = ["your-ip-address"]
    bypass         = ["AzureServices"]
  }
}
```

### 3. 監査とモニタリング

#### タグ付けの徹底

```hcl
locals {
  common_tags = {
    Environment = "Learning"
    Project     = "Terraform-Demo"
    CreatedBy   = "Terraform"
    CreatedDate = timestamp()
    Owner       = "your-email@example.com"
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}
```

#### アクティビティログの有効化

```hcl
resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "storage-account-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_storage_account.main.id]

  criteria {
    category = "Administrative"
  }
}
```

## 💰 コスト管理のベストプラクティス

### 1. リソースサイズの最適化

#### ストレージ階層の選択

```hcl
resource "azurerm_storage_account" "main" {
  # ... 他の設定

  # 用途に応じて適切な階層を選択
  account_tier = "Standard"  # Standard または Premium

  # アクセス頻度に応じた階層
  access_tier = "Hot"  # Hot, Cool, Archive
}
```

#### 不要なリソースの自動削除

```hcl
resource "azurerm_storage_management_policy" "main" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "delete-old-files"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 30
      }
    }
  }
}
```

### 2. コスト監視

#### 予算アラートの設定

```hcl
resource "azurerm_consumption_budget_resource_group" "main" {
  name              = "storage-budget"
  resource_group_id = azurerm_resource_group.main.id

  amount     = 10
  time_grain = "Monthly"

  time_period {
    start_date = "2024-01-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 80
    operator  = "GreaterThan"

    contact_emails = [
      "your-email@example.com"
    ]
  }
}
```

### 3. 開発環境でのコスト削減

#### 開発環境の夜間・休日停止

```hcl
# 開発環境用の設定
variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
}

# 開発環境では小さなサイズを使用
locals {
  storage_account_tier = var.environment == "dev" ? "Standard" : "Premium"
  replication_type     = var.environment == "dev" ? "LRS" : "GRS"
}
```

## 🛠️ 運用のベストプラクティス

### 1. 状態管理

#### リモート状態管理

```hcl
# terraform backend設定（推奨）
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "terraformstate12345"
    container_name       = "tfstate"
    key                  = "storage-demo.terraform.tfstate"
  }
}
```

**利点**:

- チーム開発での状態共有
- 状態ファイルの自動バックアップ
- 同時実行時のロック機能

#### 状態ファイルのバックアップ

```powershell
# 定期的なバックアップスクリプト
$BackupDir = ".\backups\$(Get-Date -Format 'yyyy-MM-dd')"
New-Item -ItemType Directory -Path $BackupDir -Force
Copy-Item "terraform.tfstate*" -Destination $BackupDir
```

### 2. バージョン管理

#### Terraform バージョンの固定

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"  # パッチバージョンのみ自動更新
    }
  }
}
```

#### .terraform.lock.hcl の管理

```gitignore
# .terraform.lock.hcl はコミットする（バージョン固定のため）
# .terraform/ ディレクトリは除外
.terraform/
```

### 3. コードの品質管理

#### terraform fmt の実行

```powershell
# コードフォーマットの自動修正
terraform fmt -recursive
```

#### terraform validate の実行

```powershell
# 構文チェック
terraform validate
```

#### tflint の使用

```powershell
# より詳細な静的解析
tflint
```

### 4. ドキュメント管理

#### README.md の充実

```markdown
# プロジェクト名

## 概要

このプロジェクトの目的と作成されるリソース

## 前提条件

- Terraform >= 1.0
- Azure CLI
- 必要な権限

## 使用方法

1. terraform init
2. terraform plan
3. terraform apply

## 環境変数

- TF_VAR_subscription_id: Azure サブスクリプション ID

## 作成されるリソース

- Resource Group: rg-storage-demo
- Storage Account: ユニークな名前
```

#### terraform-docs の活用

```powershell
# ドキュメント自動生成
terraform-docs markdown . > TERRAFORM.md
```

## ⚠️ トラブルシューティング

### 1. よくある問題と対処法

#### 状態ファイルの破損

```powershell
# 状態ファイルのバックアップから復元
Copy-Item "terraform.tfstate.backup" "terraform.tfstate"

# または、リソースをインポートし直す
terraform import azurerm_storage_account.main /subscriptions/.../storageAccounts/name
```

#### リソースの不整合

```powershell
# 状態を最新化
terraform refresh

# または、プランを確認して修正
terraform plan
```

#### ロックファイルの問題

```powershell
# 強制的にロックを解除（慎重に実行）
terraform force-unlock LOCK_ID
```

### 2. デバッグ方法

#### ログレベルの設定

```powershell
# 詳細ログの有効化
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform.log"
terraform apply
```

#### プロバイダーのデバッグ

```powershell
$env:TF_LOG_PROVIDER = "DEBUG"
terraform apply
```

## 📋 運用チェックリスト

### デプロイ前チェックリスト

- [ ] `.gitignore` で機密ファイルを除外している
- [ ] バージョンを適切に固定している
- [ ] `terraform validate` が成功する
- [ ] `terraform plan` の内容を確認した
- [ ] 必要な権限が付与されている
- [ ] コスト影響を見積もった

### デプロイ後チェックリスト

- [ ] すべてのリソースが正常に作成された
- [ ] タグが適切に設定されている
- [ ] セキュリティ設定が適切である
- [ ] 監視・アラートが設定されている
- [ ] ドキュメントが更新されている
- [ ] バックアップが取得されている

### 定期メンテナンスチェックリスト

- [ ] 不要なリソースの削除
- [ ] プロバイダーバージョンの更新検討
- [ ] セキュリティパッチの適用
- [ ] コスト最適化の検討
- [ ] 状態ファイルのバックアップ確認

## 🎓 学習の次のステップ

### 1. 基本スキルの習得

- [ ] Terraform の基本概念を理解
- [ ] Azure の基本サービスを理解
- [ ] HCL (HashiCorp Configuration Language) の習得

### 2. 中級スキルの習得

- [ ] モジュール化の実践
- [ ] 複数環境の管理（dev/staging/prod）
- [ ] CI/CD パイプラインとの統合
- [ ] 状態管理の高度な手法

### 3. 高級スキルの習得

- [ ] カスタムプロバイダーの開発
- [ ] Terraform Cloud の活用
- [ ] ガバナンスポリシーの実装
- [ ] 大規模環境での Terraform 運用

## 📚 参考リソース

### 公式ドキュメント

- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/)

### コミュニティリソース

- [Terraform Azure Examples](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)

これらのベストプラクティスを実践することで、安全で効率的な Terraform 運用を実現できます。まずは基本的な内容から始めて、段階的にスキルを向上させていきましょう。
