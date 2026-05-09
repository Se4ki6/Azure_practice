# Terraform Block・Provider・Resource ブロック

> 出典: [Build infrastructure – Write configuration](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#write-configuration)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > Build infrastructure」の設定記述セクションを起点に、Claudeが自動生成した教材です。

## 概要

Terraform の設定ファイル（`.tf`）は 3 つの主要ブロックで構成される。`terraform {}` でツール自体の設定、`provider {}` でクラウド接続の設定、`resource {}` で作成するリソースを定義する。

## 公式docsに沿った解説

### Write configuration（設定ファイルの記述）

Terraform の設定は HCL（HashiCorp Configuration Language）で書く。慣習として `main.tf` がエントリポイントになる。

### Terraform Block（terraform ブロック）

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

- `required_providers`: 使用するプロバイダーと許容バージョンを宣言
- `source`: プロバイダーの取得元（`<namespace>/<name>` 形式）
- `version`: バージョン制約。`~> 3.0` は「3.x 系の最新」を意味する

### Providers（provider ブロック）

```hcl
provider "azurerm" {
  features {}
}
```

- `features {}` は `azurerm` プロバイダーで必須のブロック（空でも必要）
- 認証情報は前の教材で設定した環境変数 `ARM_*` から自動的に読み込まれる
- `provider` ブロックで明示的にクライアントIDなどを書くことも可能だが、**環境変数が推奨**（機密情報をコードに含めないため）

### Resource（resource ブロック）

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "Japan East"
}
```

`resource` ブロックの構造：

```
resource "<リソースタイプ>" "<ローカル名>" {
  <引数> = <値>
}
```

| 要素 | 説明 | 例 |
|---|---|---|
| リソースタイプ | Azureリソースの種類 | `azurerm_resource_group` |
| ローカル名 | Terraform 設定内での参照名（任意） | `rg` |
| 引数 | リソースの設定値 | `name`, `location` |

他のリソースからの参照は `<タイプ>.<ローカル名>.<属性>` で行う：

```hcl
resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.rg.name  # 参照
  location            = azurerm_resource_group.rg.location
  ...
}
```

この参照により Terraform は依存関係を自動検出し、適切な順序でリソースを作成する。

## 重要ポイント

- `terraform {}` → ツール設定（プロバイダーのバージョン固定）
- `provider {}` → クラウド接続設定（認証・リージョン等）
- `resource {}` → 作成するリソースの定義
- リソース間の参照（`type.name.attr`）で暗黙的な依存関係が生まれる
- 認証情報はコードに書かず環境変数で渡す（セキュリティのベストプラクティス）

## コード例 / 図

**最小構成の `main.tf`（Resource Group のみ）**：

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "Japan East"
}
```

## 関連

- 議論・Q&A: [reference/terraform-resource-reference-syntax.md](reference/terraform-resource-reference-syntax.md)
- 次の教材: Task 3 → [01-basic-commands.md](../task3/01-basic-commands.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
