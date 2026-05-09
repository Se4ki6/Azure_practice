# azurerm_storage_container — Blob コンテナの定義

> 出典: [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「azurerm_storage_container」を起点に、Claudeが自動生成した教材です。

## 概要

Storage Container は Blob（ファイル）を格納する「バケット」に相当する単位。1 つの Storage Account の中に複数の Container を作れる。アクセス制御（パブリック/プライベート）を Container 単位で設定できるのが特徴。

## 公式docsに沿った解説

### Example Usage（基本的な書き方）

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoraccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "content"
  storage_account_id    = azurerm_storage_account.example.id
  container_access_type = "private"
}
```

### Arguments Reference

| 引数 | 必須 | 説明 |
|---|---|---|
| `name` | ✅ | Container 名。Storage Account 内で一意 |
| `storage_account_id` | — | 親 Storage Account の Resource Manager ID（**推奨**） |
| `storage_account_name` | — | 親 Storage Account の名前（**非推奨・廃止予定**） |
| `container_access_type` | — | アクセス制御（下表参照）。デフォルト: `private` |
| `default_encryption_scope` | — | アップロードオブジェクトの暗号化スコープ |
| `metadata` | — | メタデータ（キーと値のペア）|

**container_access_type の選択肢:**

| 値 | 説明 |
|---|---|
| `private` | 認証済みユーザーのみアクセス可能（デフォルト・推奨）|
| `blob` | Blob URL を知っていれば匿名で読み取り可能 |
| `container` | Container 内の Blob 一覧も匿名で取得可能 |

> 補足（公式docsには記載なし）: `blob` / `container` は「パブリックアクセス」を許可する設定。Storage Account 側で `allow_nested_items_to_be_public = false` にしていると、Container 側で `blob`/`container` を指定してもエラーになる。セキュリティ上、学習環境でも `private` 推奨。

### storage_account_name（非推奨）vs storage_account_id（推奨）

最新の `azurerm` プロバイダーでは `storage_account_name` は**非推奨**（Deprecated）になっており、`storage_account_id` の使用が推奨されている。

```hcl
# ❌ 非推奨（旧）
resource "azurerm_storage_container" "old" {
  name                 = "content"
  storage_account_name = azurerm_storage_account.example.name  # 非推奨
}

# ✅ 推奨（新）
resource "azurerm_storage_container" "new" {
  name               = "content"
  storage_account_id = azurerm_storage_account.example.id      # 推奨
}
```

### Attributes Reference（apply 後に参照できる属性）

| 属性 | 説明 |
|---|---|
| `id` | Container の ID |
| `has_immutability_policy` | イミュータビリティポリシーの有無 |
| `has_legal_hold` | 法的保持（Legal Hold）の有無 |
| `resource_manager_id` | Azure Resource Manager ID |

## 重要ポイント

- Container = Blob の「フォルダ」。Storage Account の中に複数作れる
- `container_access_type` は基本 `private` — 公開が必要な場合のみ変更する
- `storage_account_name` は**非推奨**。`storage_account_id` を使うこと
- `storage_account_id = azurerm_storage_account.sa.id` と書くことで依存関係が自動設定され、Storage Account が先に作られる

## コード例 / 図

**3 リソースをつなぐ完全構成（Resource Group → Storage Account → Container）:**

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-learning"
  location = "Japan East"
}

resource "azurerm_storage_account" "sa" {
  name                     = "saksrslearn001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.sa.id  # 推奨
  container_access_type = "private"
}
```

作成順序は Terraform が自動決定:
`Resource Group → Storage Account → Container`

## 関連

- 議論・Q&A: （`lesson` 中に発生したら `reference/` 配下にリンクが追加されます）
- 次のステップ: lesson で解説後、実際に apply して動作確認

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
