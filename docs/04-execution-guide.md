# 実行手順

このガイドでは、Terraform プロジェクトを実際に実行して Azure 上にリソースを作成する手順を説明します。

## 🔧 事前準備

### 1. 必要なツールのインストール

#### Terraform

```powershell
# Chocolateyを使用する場合
choco install terraform

# または公式サイトからダウンロード
# https://www.terraform.io/downloads.html
```

#### Azure CLI

```powershell
# Chocolateyを使用する場合
choco install azure-cli

# または公式サイトからダウンロード
# https://docs.microsoft.com/cli/azure/install-azure-cli
```

### 2. Azure にログイン

```powershell
# Azure CLIでログイン
az login

# サブスクリプション一覧を確認
az account list --output table

# 使用するサブスクリプションを設定
az account set --subscription "your-subscription-id"
```

### 3. 必要ファイルの準備

#### サンプルファイルの作成

```powershell
# アップロード用のサンプルファイルを作成
echo "Hello, Terraform!" > sample.txt
```

#### terraform.tfvars の設定

`terraform.tfvars`ファイルを開き、自分の環境に合わせて値を修正：

```hcl
subscription_id = "あなたのサブスクリプションID"
resource_group_name = "rg-storage-demo"
location = "Japan East"
storage_account_name = "ユニークなストレージアカウント名"
container_name = "files"
blob_name = "uploaded-file.txt"
local_file_path = "./sample.txt"
```

⚠️ **重要**: `storage_account_name`は Azure 全体で一意である必要があります。

## 🚀 実行手順

### ステップ 1: 初期化 (`terraform init`)

```powershell
terraform init
```

#### 何が起こるの？

- Azure プロバイダーをダウンロード
- `.terraform`ディレクトリを作成
- 状態管理ファイルを初期化

#### 成功時の出力例

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 4.0"...
- Installing hashicorp/azurerm v4.x.x...
- Installed hashicorp/azurerm v4.x.x

Terraform has been successfully initialized!
```

#### トラブルシューティング

- **エラー**: "terraform: command not found"
  - **解決策**: Terraform がインストールされていない or PATH が通っていない
- **エラー**: "Failed to query available provider packages"
  - **解決策**: インターネット接続を確認

### ステップ 2: 実行計画の確認 (`terraform plan`)

```powershell
terraform plan
```

#### 何が起こるの？

- 現在の状態とコードの差分を分析
- 作成・変更・削除されるリソースを表示
- 実際には何も変更しない

#### 成功時の出力例

```
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "Japan East"
      + name     = "rg-storage-demo"
    }

  # azurerm_storage_account.main will be created
  + resource "azurerm_storage_account" "main" {
      + account_tier             = "Standard"
      + account_replication_type = "LRS"
      + name                     = "azuretrainingyokoyamast"
      + location                 = "Japan East"
      + resource_group_name      = "rg-storage-demo"
    }

Plan: 4 to add, 0 to change, 0 to destroy.
```

#### 出力の読み方

- **`+`**: 新規作成
- **`~`**: 変更
- **`-`**: 削除
- **`(known after apply)`**: 実行後に決まる値

#### トラブルシューティング

- **エラー**: "Subscription not found"
  - **解決策**: `az login`でログインし直す
- **エラー**: "storage account name already exists"
  - **解決策**: `terraform.tfvars`で別のストレージアカウント名を指定

### ステップ 3: 実行 (`terraform apply`)

```powershell
terraform apply
```

#### 何が起こるの？

- plan で計算した変更を実際に適用
- Azure のリソースを作成
- 状態ファイル（`terraform.tfstate`）を更新

#### 実行フロー

1. 実行計画を再表示
2. 確認プロンプトが表示：`Enter a value: yes`
3. リソースの作成開始
4. 各リソースの作成状況を表示
5. 完了時に出力値を表示

#### 成功時の出力例

```
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s

azurerm_storage_account.main: Creating...
azurerm_storage_account.main: Creation complete after 45s

azurerm_storage_container.main: Creating...
azurerm_storage_container.main: Creation complete after 5s

azurerm_storage_blob.main: Creating...
azurerm_storage_blob.main: Creation complete after 3s

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

blob_url = "https://azuretrainingyokoyamast.blob.core.windows.net/files/uploaded-file.txt"
resource_group_name = "rg-storage-demo"
storage_account_name = "azuretrainingyokoyamast"
```

#### 自動実行（確認スキップ）

```powershell
terraform apply -auto-approve
```

### ステップ 4: 結果の確認

#### Azure Portal での確認

1. [Azure Portal](https://portal.azure.com) にアクセス
2. リソースグループ `rg-storage-demo` を検索
3. 作成されたリソースを確認：
   - ストレージアカウント
   - Blob コンテナ
   - アップロードされたファイル

#### Azure CLI での確認

```powershell
# リソースグループの確認
az group show --name rg-storage-demo

# ストレージアカウントの確認
az storage account list --resource-group rg-storage-demo --output table

# Blobファイルの確認
az storage blob list --account-name azuretrainingyokoyamast --container-name files --output table
```

#### Terraform での確認

```powershell
# 出力値の確認
terraform output

# 特定の出力のみ確認
terraform output storage_account_name

# JSON形式で出力
terraform output -json
```

## 🗑️ リソースの削除

学習が終わったら、課金を停止するためにリソースを削除しましょう。

### 方法 1: Terraform で削除（推奨）

```powershell
terraform destroy
```

#### 実行フロー

1. 削除される予定のリソースを表示
2. 確認プロンプト：`Enter a value: yes`
3. 依存関係を考慮してリソースを削除
4. 状態ファイルをクリア

#### 成功時の出力例

```
azurerm_storage_blob.main: Destroying...
azurerm_storage_blob.main: Destruction complete after 2s

azurerm_storage_container.main: Destroying...
azurerm_storage_container.main: Destruction complete after 3s

azurerm_storage_account.main: Destroying...
azurerm_storage_account.main: Destruction complete after 30s

azurerm_resource_group.main: Destroying...
azurerm_resource_group.main: Destruction complete after 45s

Destroy complete! Resources: 4 destroyed.
```

### 方法 2: Azure Portal で削除

1. Azure Portal にアクセス
2. リソースグループ `rg-storage-demo` を選択
3. 「リソースグループの削除」をクリック
4. リソースグループ名を入力して削除

⚠️ **注意**: Portal で削除した場合、Terraform の状態ファイルと実際の状態が不整合になります。

## 📊 状態管理について

### terraform.tfstate ファイル

- Terraform が管理するリソースの現在の状態を記録
- 実際のクラウドリソースとの対応関係を保持
- **絶対に手動編集してはいけません**

### 状態ファイルの内容確認

```powershell
# 状態の一覧表示
terraform state list

# 特定のリソースの詳細表示
terraform state show azurerm_storage_account.main
```

### 状態ファイルのバックアップ

```powershell
# 手動バックアップ
copy terraform.tfstate terraform.tfstate.backup

# Terraformは自動的に .backup ファイルを作成
```

## 🔄 変更の適用

設定を変更して再度適用する場合：

### 1. ファイルを編集

例：Blob ファイル名を変更

```hcl
# terraform.tfvars
blob_name = "new-file-name.txt"
```

### 2. 変更計画を確認

```powershell
terraform plan
```

### 3. 変更を適用

```powershell
terraform apply
```

Terraform は差分のみを適用します（古い Blob を削除し、新しい Blob を作成）。

## ⚠️ よくあるエラーと対処法

### 1. "Storage account name already exists"

**原因**: ストレージアカウント名がすでに使用されている
**対処法**: `terraform.tfvars`で別の名前を指定

### 2. "Subscription not found"

**原因**: Azure 認証の問題
**対処法**: `az login` で再ログイン

### 3. "File not found: ./sample.txt"

**原因**: アップロード対象のファイルが存在しない
**対処法**: ファイルを作成するか、パスを修正

### 4. "Resource group already exists"

**原因**: 同名のリソースグループがすでに存在
**対処法**: 別の名前を使用するか、既存のものを削除

### 5. "Terraform state lock"

**原因**: Terraform の実行が途中で中断された
**対処法**:

```powershell
terraform force-unlock LOCK_ID
```

## 📋 実行チェックリスト

実行前の確認事項：

- [ ] Terraform がインストールされている
- [ ] Azure CLI がインストールされている
- [ ] Azure にログインしている
- [ ] `terraform.tfvars`に正しい値が設定されている
- [ ] `sample.txt`ファイルが存在している
- [ ] ストレージアカウント名がユニークである

実行後の確認事項：

- [ ] すべてのリソースが正常に作成された
- [ ] Azure Portal で作成されたリソースを確認した
- [ ] 出力値が期待通りに表示されている
- [ ] 不要になったらリソースを削除した

これで実際に Terraform を使って Azure リソースを作成できます。次は [注意事項とベストプラクティス](./05-best-practices.md) でより安全で効率的な運用方法を学びましょう。
