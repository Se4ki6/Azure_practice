# Azure - Azure × Terraform 学習Phase設計書

## 概要

Blob ストレージ + 基本インフラ一式 を Azure × Terraform 学習を主目的として段階的に構築する。各Phaseで新規概念を1-2個ずつ導入し、じっくり理解しながら成熟させる。

## 設計方針

- **1 Phaseあたり新規概念は1-2個** に抑え、段階的に学ぶ
- **成熟度軸** で進める: 最初はシンプルに動かし、同じ機能をより洗練された形に育てる
- **機能追加と運用改善を織り交ぜる**: 新機能だけでなく、監視・セキュリティ・テスト等の運用スキルも習得する

## 全体像

| Phase | テーマ | 新規概念 | 状態 |
|---|---|---|---|
| Phase 1 | Terraform × Azure 基礎 | プロバイダー設定・認証・init/plan/apply | 未着手 |
| Phase 2 | Azure コアリソース | Resource Group / Storage Account / Blob Container | 未着手 |
| Phase 3 | 変数・モジュール化 | variables / locals / modules | 未着手 |
| Phase 4 | 状態管理（Remote Backend） | terraform.tfstate を Azure Blob で管理 | 未着手 |
| Phase 5 | セキュリティ・運用 | RBAC / ネットワーク制御 / タグ管理 | 未着手 |

---

## Phase 1: Terraform × Azure 基礎

**ゴール**: Terraform で Azure に接続し、最初のリソースを apply できる状態になる

**新規概念**:
- Terraform プロバイダー（`azurerm`）の設定
- Azure CLI 認証（`az login`）と Terraform の連携
- `terraform init` / `plan` / `apply` / `destroy` の基本フロー

**Taskの目安**:
- Task 1: 環境構築（Azure CLI + Terraform インストール確認、`az login`）
- Task 2: `provider.tf` の作成と `terraform init`
- Task 3: 最小リソース（Resource Group）を apply して動作確認

---

## Phase 2: Azure コアリソース

**ゴール**: Storage Account と Blob Container を Terraform で作成・管理できる

**新規概念**:
- `azurerm_resource_group` / `azurerm_storage_account` / `azurerm_storage_container` リソース
- Storage Account の設定項目（tier / replication / kind）
- Terraform の依存関係（`depends_on` vs 暗黙的参照）

**Taskの目安**:
- Task 1: Storage Account の作成
- Task 2: Blob Container の作成
- Task 3: outputs で接続情報を取り出す

---

## Phase 3: 変数・モジュール化

**ゴール**: ハードコードをなくし、再利用可能な Terraform コードに育てる

**新規概念**:
- `variable` / `local` / `output` の使い分け
- `terraform.tfvars` での環境別設定
- `module` ブロックによるコードの分割

**Taskの目安**:
- Task 1: variables.tf の整備と tfvars の分離
- Task 2: Storage モジュールの切り出し
- Task 3: 複数環境（dev/prod）への適用

---

## Phase 4: 状態管理（Remote Backend）

**ゴール**: `terraform.tfstate` を Azure Blob に置き、チーム開発・CI/CD に対応できる状態にする

**新規概念**:
- `terraform.tfstate` の役割と local vs remote
- `backend "azurerm"` の設定
- State ロック（同時 apply 防止）

**Taskの目安**:
- Task 1: tfstate の役割理解
- Task 2: Azure Blob Backend の設定
- Task 3: State のマイグレーション（local → remote）

---

## Phase 5: セキュリティ・運用

**ゴール**: 本番運用を意識したセキュリティ設定と運用フローを身につける

**新規概念**:
- RBAC（`azurerm_role_assignment`）
- ネットワーク制御（Storage Firewall / Private Endpoint 入門）
- タグ戦略とコスト管理

**Taskの目安**:
- Task 1: Storage Account のセキュリティ設定強化
- Task 2: RBAC でアクセス制御
- Task 3: タグ管理と terraform-docs による運用ドキュメント化

---

## Phase間の依存関係

各Phaseは前のPhaseの成果物を前提に進む。Phase 4 の Remote Backend は Phase 2 で作った Storage Account を流用する。

## 最終アーキテクチャ / 到達点

Phase 5 完了時点で到達する状態:
- Resource Group に Storage Account + Blob Container が存在
- tfstate が Azure Blob で管理されている
- RBAC で適切なアクセス制御が設定されている
- 変数・モジュールで再利用可能な構成になっている

---

_Generated at 2026-05-09 by learning-flow plugin_
