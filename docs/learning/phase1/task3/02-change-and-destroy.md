# インフラの変更と削除

> 出典: [Change infrastructure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-change) / [Destroy infrastructure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-destroy)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > Change / Destroy infrastructure」を起点に、Claudeが自動生成した教材です。

## 概要

Terraform の強みは「変更」と「削除」も宣言的に管理できること。設定ファイルを書き換えて `terraform apply` するだけで差分のみを自動反映する。不要になったリソースは `terraform destroy` で一括削除できる。

## 公式docsに沿った解説

### Create a new resource（新規リソースの追加）

既存の `main.tf` に新しい `resource` ブロックを追記し、`terraform apply` を実行するだけで追加できる。

例：Virtual Network を追加する：

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}
```

`resource_group_name = azurerm_resource_group.rg.name` という参照により、Terraform は Resource Group が先に存在することを自動的に把握し、正しい順序で作成する。

### Apply your changes（変更の適用）

```shell
terraform apply
```

plan 出力に `+` で新規追加分のみが表示される。既存リソースは触られない。

### Modify an existing resource（既存リソースの変更）

既存リソースのブロックに属性を追加・変更して `apply` する。例：Resource Group にタグを追加：

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "Japan East"

  tags = {
    Environment = "Development"
    Team        = "Learning"
  }
}
```

plan 出力に `~`（インプレース更新）として表示される。リソースを削除・再作成せず、属性だけを変更する。

### Review updates to state（状態の更新確認）

apply 後に `terraform show` で更新されたステートを確認できる。タグが反映されていることを確認するのがよい習慣。

```shell
terraform show
terraform state list
```

### Destroy（インフラの削除）

```shell
terraform destroy
```

Terraform が管理するすべてのリソースを削除する。plan と同様に実行計画を表示し、`yes` の確認後に削除を実行する。

削除順序は依存関係の逆順 — 依存されているリソースが最後に削除される。

```shell
# 確認なしで即時削除（CI用・注意して使う）
terraform destroy -auto-approve
```

> 補足（公式docsには記載なし）: `destroy` は**すべて**のリソースを削除する。特定リソースだけ削除したい場合は `terraform destroy -target=<リソースタイプ>.<名前>` を使う。

## 重要ポイント

- 変更はコードを書き換えて `terraform apply` するだけ — Terraform が差分を計算
- `+` = 新規追加 / `~` = 更新 / `-` = 削除 / `-/+` = 再作成 が plan で確認できる
- `terraform destroy` はすべてのリソースを削除 — 本番環境では慎重に
- 依存関係がある場合、Terraform が正しい順序で作成・削除を自動調整する

## コード例 / 図

**変更ワークフロー：**

```shell
# 1. main.tf を編集
# 2. 変更のプレビュー
terraform plan

# 3. 変更を反映
terraform apply

# 4. 状態を確認
terraform show
```

**削除ワークフロー：**

```shell
# 管理リソースをすべて削除
terraform destroy

# 確認プロンプトに "yes" を入力
```

## 関連

- 議論・Q&A: （`lesson` 中に発生したら `reference/` 配下にリンクが追加されます）
- Phase 2 へ → [Phase 2 / Task 1](../../phase2/task1/main.md)（次Phaseで Blob Storage を作成）

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
