# Azure Storage Account Terraform Project

このプロジェクトは、**Terraform**を使って**Azure Storage Account**を作成し、ローカルファイルを Blob ストレージにアップロードするインフラ初学者向けのサンプルプロジェクトです。

## 🎯 学習目標

- Azure の基本概念を理解する
- Terraform の基本的な使い方を覚える
- Infrastructure as Code (IaC) の考え方を身につける
- 実際にクラウドリソースを作成・管理する体験をする

## 📋 このプロジェクトで作成されるリソース

- **Azure Resource Group**: リソースをまとめる論理的なコンテナ
- **Azure Storage Account**: ファイル保存用のクラウドストレージ
- **Blob Container**: ファイルを整理するためのコンテナ
- **Blob File**: ローカルファイルをクラウドにアップロード

## 📚 詳細ドキュメント

このプロジェクトには包括的なドキュメントが含まれています：

- [📖 総合ガイド](./docs/README.md) - プロジェクト全体の概要
- [☁️ Azure 基礎知識](./docs/01-azure-basics.md) - Azure の基本概念
- [🛠️ Terraform 基礎知識](./docs/02-terraform-basics.md) - Terraform の仕組み
- [📁 ファイル構成解説](./docs/03-file-structure.md) - 各ファイルの詳細説明
- [🚀 実行手順](./docs/04-execution-guide.md) - ステップバイステップガイド
- [⭐ ベストプラクティス](./docs/05-best-practices.md) - セキュリティと運用のポイント

## 📁 ファイル構成

```
├── main.tf                     # メインのリソース定義
├── variables.tf                # 変数定義
├── outputs.tf                  # 出力定義
├── providers.tf                # プロバイダー設定
├── terraform.tfvars.template   # 変数値テンプレート
├── sample.txt.template         # サンプルファイルテンプレート
├── README.md                   # このファイル
├── .gitignore                  # Git除外設定
└── docs/                       # 詳細ドキュメント
    ├── README.md
    ├── 01-azure-basics.md
    ├── 02-terraform-basics.md
    ├── 03-file-structure.md
    ├── 04-execution-guide.md
    └── 05-best-practices.md
```

## 🔧 クイックスタート

### 前提条件

- [Terraform](https://www.terraform.io/downloads.html) がインストールされている
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) がインストールされている
- Azure サブスクリプションへのアクセス権限がある

### 実行手順

#### 1. リポジトリをクローン

```bash
git clone <このリポジトリのURL>
cd Azure
```

#### 2. Azure にログイン

```powershell
az login
```

#### 3. 設定ファイルを準備

```powershell
# 変数ファイルをテンプレートからコピー
Copy-Item terraform.tfvars.template terraform.tfvars

# サンプルファイルをテンプレートからコピー
Copy-Item sample.txt.template sample.txt
```

#### 4. terraform.tfvars を編集

`terraform.tfvars` ファイルを開き、以下の値を設定：

- `subscription_id`: あなたの Azure サブスクリプション ID
- `storage_account_name`: グローバルで一意なストレージアカウント名

#### 5. Terraform を実行

```powershell
# 初期化
terraform init

# 実行計画を確認
terraform plan

# リソースを作成
terraform apply
```

#### 6. 片付け（重要！）

```powershell
# 課金を停止するためにリソースを削除
terraform destroy
```

⚠️ **重要**: 学習が終わったら必ず `terraform destroy` でリソースを削除してください。放置すると継続的に課金されます。

## 🛡️ セキュリティ注意事項

このプロジェクトは GitHub 上で安全に共有できるよう設計されています：

### 🔒 機密情報の保護

- `.gitignore` で機密ファイルを除外設定済み
- `terraform.tfvars` (実際の設定値) は Git 管理対象外
- `terraform.tfvars.template` のみを提供し、実際の値は各自で設定

### ⚠️ 絶対に共有してはいけないファイル

- `terraform.tfvars` - サブスクリプション ID などの機密情報
- `terraform.tfstate*` - インフラの詳細状態情報
- `.terraform/` - プロバイダーの設定情報

### ✅ 安全に共有できるファイル

- `*.tf` - Terraform コード
- `*.template` - テンプレートファイル
- `docs/` - ドキュメント
- `README.md` - このファイル

## 💰 コスト情報

このプロジェクトで作成されるリソースの概算コスト：

- **Storage Account (Standard LRS)**: 約 ¥2-5/月
- **Blob Storage**: データ量に応じて（少量なら ¥1 未満/月）
- **トランザクション**: 読み書き操作に応じて（学習用途なら微小）

**総額**: 月額 ¥10 以下（学習用途の場合）

⚠️ **注意**: 不要になったら必ず削除してください！

## 🤝 コントリビューション

このプロジェクトへの改善提案やフィードバックを歓迎します：

1. **Issue**: バグ報告や改善提案
2. **Pull Request**: コード改善や新機能追加
3. **Discussion**: 質問や議論

### 貢献時の注意事項

- 機密情報を含まないことを確認
- ドキュメントの更新も併せて実施
- 初学者にとってわかりやすい内容を心がける

## 📚 関連リソース

### 公式ドキュメント

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### 学習リソース

- [Microsoft Learn - Azure Fundamentals](https://docs.microsoft.com/learn/paths/azure-fundamentals/)
- [HashiCorp Learn - Terraform](https://learn.hashicorp.com/terraform)

## 📄 ライセンス

MIT License - 詳細は LICENSE ファイルを参照

## 🏷️ タグ

`terraform` `azure` `infrastructure-as-code` `cloud` `storage` `learning` `japanese` `初学者向け`

```powershell
terraform output storage_account_primary_key
terraform output storage_account_connection_string
```

## 注意事項

- ストレージアカウント名はグローバルで一意である必要があります
- 小文字と数字のみ使用可能で、3-24 文字の制限があります
- デフォルトでは private コンテナが作成されます
- 作成されたリソースには課金が発生する可能性があります
