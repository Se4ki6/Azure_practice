# Terraform のインストール

> 出典: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > Install Terraform」を起点に、Claudeが自動生成した教材です。

## 概要

Terraform はバイナリ単体で動作する Go 製ツール。パッケージマネージャーまたは手動インストールで導入できる。インストール後は `terraform -help` で動作確認する。

## 公式docsに沿った解説

### Install Terraform（インストール方法）

OS ごとの推奨インストール方法：

| OS | 推奨方法 |
|---|---|
| **Windows** | `winget install HashiCorp.Terraform` または Chocolatey |
| **macOS** | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` |
| **Linux（Ubuntu/Debian）** | HashiCorp の APT リポジトリを追加してインストール |
| **手動** | [releases.hashicorp.com](https://releases.hashicorp.com/terraform/) からバイナリをダウンロード |

### Terraform versions and compatibility（バージョンと互換性）

HashiCorp は定期的に新バージョンをリリースしており、バージョン間の互換性を保つよう設計されている。設定ファイル内の `required_version` で使用する Terraform のバージョンを固定できる（推奨）。

### Verify the Installation（インストール確認）

```shell
terraform -help
```

エラーなく使用可能なサブコマンド一覧が表示されれば成功。

```shell
terraform -help plan
```

特定コマンドのヘルプも確認できる。

### Enable tab completion（タブ補完の有効化）

Bash / Zsh でタブ補完を有効化するには：

```shell
terraform -install-autocomplete
```

実行後にシェルを再起動すると有効になる。

## 重要ポイント

- Terraform はシングルバイナリ — インストールは単純、依存関係なし
- Windows は `winget` または Chocolatey が最も手軽
- インストール後は必ず `terraform -help` で動作確認する
- 本番プロジェクトでは `required_version` でバージョンを固定する（後述）

## コード例

```shell
# Windows（winget）
winget install HashiCorp.Terraform

# インストール確認
terraform -help

# バージョン確認
terraform version
```

## 関連

- 議論・Q&A: （`lesson` 中に発生したら `reference/` 配下にリンクが追加されます）
- 次の教材: Task 2 → [01-azure-auth.md](../task2/01-azure-auth.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
