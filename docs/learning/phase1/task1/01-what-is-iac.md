# Infrastructure as Code（IaC）とは

> 出典: [What is Infrastructure as Code with Terraform?](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > What is Infrastructure as Code?」を起点に、Claudeが自動生成した教材です。

## 概要

Terraform は HashiCorp が開発する Infrastructure as Code（IaC）ツール。インフラを「コード」として宣言的に定義し、安全・一貫・再現可能な方法で構築・変更・管理できる。プロバイダーと呼ばれるプラグインを通じて、Azure・AWS・GCP をはじめ 1,000 以上のサービスに対応している。

## 公式docsに沿った解説

### Manage any infrastructure（あらゆるインフラを管理）

Terraform は **プロバイダー**（Provider）というプラグインを通じてクラウドプラットフォームの API を呼び出す。Azure 向けの `azurerm` プロバイダーを使うことで、Terraform のコードから Azure リソースを CRUD 操作できる。

### Standardize your deployment workflow（デプロイワークフローの標準化）

Terraform は**宣言的**（declarative）な設定言語（HCL）を使う。「どうやって作るか」ではなく「何を作るか」を書くだけで、Terraform が差分を計算して実行してくれる。

デプロイのステップは 5 段階：

| ステップ | 内容 |
|---|---|
| **Scope** | 必要なインフラを特定する |
| **Author** | HCL で設定ファイルを書く |
| **Initialize** | `terraform init` でプロバイダープラグインを取得 |
| **Plan** | `terraform plan` で変更内容をプレビュー |
| **Apply** | `terraform apply` で実際にインフラを構築 |

### Track your infrastructure（インフラの状態追跡）

Terraform は `terraform.tfstate`（ステートファイル）に現在のインフラ状態を記録する。このファイルが「Terraform から見た現実」となり、次回 plan/apply 時の差分計算に使われる。

### Collaborate（チームでの協働）

ステートファイルをリモートバックエンド（Azure Blob 等）に置くことでチーム共有・ロック管理が可能になる（Phase 4 で詳しく学ぶ）。

## 重要ポイント

- Terraform は**宣言的 IaC** — 手順書を書くのではなく「あるべき姿」を書く
- **プロバイダー** = Terraform と各クラウド API を繋ぐプラグイン
- **ステートファイル** = Terraform が管理するインフラの「現実の写し」
- 5ステップ（Scope → Author → Init → Plan → Apply）がワークフローの基本

## 関連

- 議論・Q&A: [reference/azurerm-provider-plugin-mechanism.md](reference/azurerm-provider-plugin-mechanism.md)
- 議論・Q&A: [reference/tfstate-team-collaboration-problem.md](reference/tfstate-team-collaboration-problem.md)
- 次の教材: [02-install-terraform.md](02-install-terraform.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
