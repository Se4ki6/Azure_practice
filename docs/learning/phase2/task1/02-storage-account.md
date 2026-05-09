# azurerm_storage_account — ストレージアカウントの定義

> 出典: [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「azurerm_storage_account」を起点に、Claudeが自動生成した教材です。

## 概要

Storage Account は Blob・File・Queue・Table など Azure ストレージサービスの「ネームスペース」。Blob Container を作る前に必ず Storage Account が必要。設定項目が多いリソースだが、学習段階では `account_tier` / `account_replication_type` / `account_kind` の 3 つを押さえるのが最優先。

## 公式docsに沿った解説

### Example Usage（基本的な書き方）

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
```

### Arguments Reference — 必須引数

| 引数 | 説明 |
|---|---|
| `name` | Storage Account 名。**グローバルで一意**。3〜24 文字の小文字英数字のみ |
| `resource_group_name` | 所属する Resource Group 名 |
| `location` | Azure リージョン |
| `account_tier` | `Standard`（汎用）または `Premium`（高性能SSD）|
| `account_replication_type` | データの冗長化方式（下表参照）|

**account_replication_type の選択肢:**

| 値 | 正式名称 | 概要 |
|---|---|---|
| `LRS` | ローカル冗長 | 同一データセンター内に 3 コピー。最安価 |
| `ZRS` | ゾーン冗長 | 同一リージョンの 3 ゾーンに分散 |
| `GRS` | 地理冗長 | LRS + 別リージョンにも複製。障害時は読み取り不可 |
| `RAGRS` | 読み取りアクセス地理冗長 | GRS + 別リージョンから読み取り可能 |
| `GZRS` | 地理ゾーン冗長 | ZRS + 別リージョンにも複製 |
| `RAGZRS` | 読み取りアクセス地理ゾーン冗長 | GZRS + 別リージョンから読み取り可能 |

### Arguments Reference — オプション引数（重要なもの）

| 引数 | デフォルト | 説明 |
|---|---|---|
| `account_kind` | `StorageV2` | ストレージの種類。学習では `StorageV2` のままでよい |
| `https_traffic_only_enabled` | `true` | HTTPS のみ許可。セキュリティのため `true` 推奨 |
| `min_tls_version` | `TLS1_2` | 最小 TLS バージョン。`TLS1_2` 推奨 |
| `shared_access_key_enabled` | `true` | アクセスキー認証の有効化 |
| `public_network_access_enabled` | `true` | パブリックネットワークからのアクセス |

### Attributes Reference（apply 後に参照できる属性）

| 属性 | 説明 |
|---|---|
| `id` | Storage Account の Resource Manager ID |
| `primary_blob_endpoint` | Blob サービスのエンドポイント URL |
| `primary_access_key` | アクセスキー（機密情報、`sensitive = true`）|
| `primary_connection_string` | 接続文字列（機密情報、`sensitive = true`）|

> 補足（公式docsには記載なし）: `primary_access_key` や `primary_connection_string` は `output` で出力する際に `sensitive = true` を付けないと terraform plan/apply 時に値が表示されてしまう。

## 重要ポイント

- Storage Account 名は **グローバルで一意** — 他の誰かがすでに使っている名前は使えない
- `account_tier` + `account_replication_type` の組み合わせが料金とSLAを決定
- 学習環境では `Standard` + `LRS` が最安価
- `https_traffic_only_enabled = true`（デフォルト）は変えないこと — セキュリティのベストプラクティス
- `primary_access_key` は outputs で出す場合 `sensitive = true` 必須

## コード例 / 図

**学習用の最小構成（Standard + LRS）:**

```hcl
resource "azurerm_storage_account" "sa" {
  name                     = "saksrslearn001"      # グローバルで一意な名前
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"                 # 最安価・学習用

  https_traffic_only_enabled = true                # セキュリティのデフォルト
  min_tls_version            = "TLS1_2"
}
```

## 関連

- 議論・Q&A: [reference/azure-storage-types-vs-aws.md](reference/azure-storage-types-vs-aws.md)
- 議論・Q&A: [reference/storage-replication-types.md](reference/storage-replication-types.md)
- 次の教材: [03-storage-container.md](03-storage-container.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
