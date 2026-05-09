# AWS S3 vs Azure Blob Storage — Terraform 記述比較

> 種別: ユーザー議論・Q&A の記録（Phase 2 / Task 1）
> 関連教材: [03-storage-container.md](../03-storage-container.md)

## 概要

AWS で S3 バケットを作る際の Terraform 記述と、Azure で Blob Storage を作る際の記述を並べた比較ドキュメント。
リソース構造の違い（Azure は Storage Account という中間層がある）を中心に整理する。

---

## リソース構造の違い

```
AWS
└── S3 Bucket（= バケット単体で独立）

Azure
└── Resource Group
    └── Storage Account（ネームスペース）
        └── Blob Container（バケット相当）
```

Azure は Storage Account という「器」が必要なため、Terraform で定義するリソース数が多い。

---

## Terraform 記述比較

### AWS（S3）

```hcl
# プロバイダー設定
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"  # 東京リージョン
}

# S3 バケット（バケット単体で作れる）
resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket-name"
}

# アクセス制御（パブリックアクセス遮断）
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### Azure（Blob Storage）

```hcl
# プロバイダー設定
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ① リソースグループ（AWS には相当物なし。リソースをまとめる管理単位）
resource "azurerm_resource_group" "rg" {
  name     = "rg-learning"
  location = "Japan East"
}

# ② ストレージアカウント（AWS には相当物なし。S3 のネームスペース相当）
resource "azurerm_storage_account" "sa" {
  name                     = "sksrdlearn001"       # グローバル一意・3〜24文字
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ③ Blob コンテナ（= S3 バケット相当）
resource "azurerm_storage_container" "container" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.sa.id  # 4.x 推奨
  container_access_type = "private"
}
```

---

## 項目別比較表

| 項目 | AWS (S3) | Azure (Blob) |
|---|---|---|
| **プロバイダー** | `hashicorp/aws` | `hashicorp/azurerm` |
| **認証** | `~/.aws/credentials` or 環境変数 `AWS_*` | `az login` or 環境変数 `ARM_*` |
| **リージョン指定** | `provider` ブロックの `region` | `resource` ごとの `location` |
| **「バケット」相当** | `aws_s3_bucket` | `azurerm_storage_container` |
| **中間層** | なし | `azurerm_storage_account`（必須） |
| **名前のユニーク性** | グローバル一意（S3 バケット名） | Storage Account 名がグローバル一意 |
| **アクセス制御** | `aws_s3_bucket_public_access_block` | `container_access_type = "private"` |
| **依存関係** | バケット単体で独立 | RG → SA → Container の順で依存 |
| **定義リソース数** | 最小 1〜2 個 | 最小 3 個 |

---

## 依存関係の表現方法

どちらも **参照式** を使って暗黙的に依存を表現する（Terraform が自動的に順番を解決）。

```hcl
# AWS: バケット名を別リソースから参照する例
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id  # type.local_name.attribute
  ...
}

# Azure: Storage Account の情報を Container から参照
resource "azurerm_storage_container" "container" {
  storage_account_id = azurerm_storage_account.sa.id  # 同じ記法
}
```

参照式の書き方は `<type>.<local_name>.<attribute>` で AWS も Azure も共通。

---

## apply 後の確認コマンド比較

```bash
# AWS: バケット一覧
aws s3 ls

# Azure: コンテナ一覧
az storage container list \
  --account-name sksrdlearn001 \
  --auth-mode login \
  --output table
```

---

## 参考文献

- [aws_s3_bucket — Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
- [azurerm_storage_account — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

---

_Saved at 2026-05-09 via /learning-flow:reference_
