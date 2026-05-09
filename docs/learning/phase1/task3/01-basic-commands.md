# Terraform 基本コマンド（init / fmt / validate / apply / state）

> 出典: [Build infrastructure – Initialize and apply](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#initialize-the-directory)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > Build infrastructure」のコマンド実行セクションを起点に、Claudeが自動生成した教材です。

## 概要

Terraform の基本ワークフローは `init → fmt → validate → plan → apply` の 5 コマンドで構成される。さらに `terraform show` / `terraform state list` でリソースの現在状態を確認できる。

## 公式docsに沿った解説

### terraform init（初期化）

```shell
terraform init
```

プロジェクトディレクトリの初回（またはプロバイダー変更後）に実行する。以下を行う：

- `required_providers` で宣言したプロバイダープラグインを `.terraform/` にダウンロード
- `.terraform.lock.hcl`（プロバイダーのバージョンロックファイル）を生成・更新

`.terraform/` と `.terraform.lock.hcl` はプロジェクトに必須。`.terraform/` は `.gitignore` に追加する（バイナリのためサイズが大きい）。

### terraform fmt（フォーマット）

```shell
terraform fmt
```

HCL ファイルを標準スタイルに自動整形する。インデントや空白の統一。差分があったファイル名が出力される。CI に組み込んで `terraform fmt -check` でスタイル違反を検知するのが一般的。

### terraform validate（検証）

```shell
terraform validate
```

設定ファイルの**構文エラー**と**型エラー**を静的に検証する。実際に Azure API を叩かないため高速。`Success! The configuration is valid.` が表示されれば OK。

### terraform plan（プレビュー）

```shell
terraform plan
```

実際に変更を加える前に「何が作成・変更・削除されるか」を表示する。

出力の記号の意味：

| 記号 | 意味 |
|---|---|
| `+` | 新規作成 |
| `~` | インプレース更新 |
| `-` | 削除 |
| `-/+` | 削除して再作成 |

### terraform apply（適用）

```shell
terraform apply
```

plan の内容を表示し `yes` の確認を求める。確認後、実際に Azure へリソースを作成する。

```shell
# 確認なしで即時実行（CI用）
terraform apply -auto-approve
```

apply 完了後、`terraform.tfstate` が更新される。

### Inspect your state（状態の確認）

```shell
# ステートの全内容を表示
terraform show

# 管理中リソースの一覧
terraform state list

# 特定リソースの詳細
terraform state show azurerm_resource_group.rg
```

## 重要ポイント

- `init` はプロバイダープラグインのダウンロード — プロジェクト開始時・プロバイダー変更後に必ず実行
- `plan` は**変更のプレビュー**、`apply` が**実際の反映** — 必ず plan で確認してから apply
- `fmt` と `validate` はコミット前に習慣化する
- `terraform.tfstate` は Terraform が管理する「現実の写し」 — 手動で編集しない
- `.terraform/` ディレクトリは `.gitignore` に追加する

## コード例 / 図

**標準的な実行フロー：**

```shell
# 1. 初期化
terraform init

# 2. フォーマット確認
terraform fmt

# 3. 構文検証
terraform validate

# 4. 変更のプレビュー
terraform plan

# 5. 実際に適用
terraform apply

# 6. 状態確認
terraform state list
terraform show
```

## 関連

- 議論・Q&A: （`lesson` 中に発生したら `reference/` 配下にリンクが追加されます）
- 次の教材: [02-change-and-destroy.md](02-change-and-destroy.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
