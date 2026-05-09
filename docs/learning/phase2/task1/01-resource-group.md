# azurerm_resource_group — リソースグループの定義

> 出典: [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「azurerm_resource_group」を起点に、Claudeが自動生成した教材です。

## 概要

Azure のすべてのリソースは必ず Resource Group（リソースグループ）に属する。Terraform で Azure リソースを作る際は、最初に Resource Group を定義するのが基本パターン。シンプルなリソースだが、他のすべてのリソースの「入れ物」として重要な役割を担う。

## 公式docsに沿った解説

### Example Usage（基本的な書き方）

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "West Europe"
}
```

Resource Group は `name` と `location` の 2 つだけで作成できる最小構成のリソース。

### Arguments Reference（設定できる引数）

| 引数 | 必須 | 説明 |
|---|---|---|
| `name` | ✅ | Resource Group の名前。Azure サブスクリプション内で一意である必要がある |
| `location` | ✅ | Azure リージョン（例: `"Japan East"`, `"West Europe"`） |
| `managed_by` | — | このグループを管理するリソースまたはアプリケーションの ID |
| `tags` | — | タグ（キーと値のペア）。コスト管理・運用管理に使う |

> 補足（公式docsには記載なし）: `location` に指定できるリージョン名の一覧は `az account list-locations --output table` で確認できる。

### Attributes Reference（apply 後に参照できる属性）

| 属性 | 説明 |
|---|---|
| `id` | Resource Group の Azure Resource Manager ID（例: `/subscriptions/{sub-id}/resourceGroups/{name}`） |

### Timeouts（タイムアウト設定）

| 操作 | デフォルト |
|---|---|
| 作成 / 更新 | 90 分 |
| 読み取り | 5 分 |
| 削除 | 90 分 |

### Import（既存リソースの取り込み）

Portal や CLI で作成済みの Resource Group を Terraform 管理下に取り込める:

```shell
terraform import azurerm_resource_group.example \
  /subscriptions/{subscription-id}/resourceGroups/{group-name}
```

## 重要ポイント

- Resource Group はすべての Azure リソースの「親」— 先に作成し、他リソースから `azurerm_resource_group.example.name` / `.location` で参照する
- `name` と `location` だけで作れる最小リソース
- `id` 属性は apply 後に Azure が払い出す — RBAC 設定や他リソースのスコープ指定に使う
- タグを活用するとコスト分析・環境識別がしやすくなる（Phase 5 で詳しく扱う）

## コード例 / 図

**他リソースからの参照パターン（推奨）:**

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-learning"
  location = "Japan East"
  tags = {
    Environment = "Development"
  }
}

# Storage Account は rg を参照して location/name を受け取る
resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.rg.name      # 参照
  location            = azurerm_resource_group.rg.location  # 参照
  ...
}
```

## 関連

- 議論・Q&A: [reference/resource-group-vs-csharp-sln.md](reference/resource-group-vs-csharp-sln.md)
- 次の教材: [02-storage-account.md](02-storage-account.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
