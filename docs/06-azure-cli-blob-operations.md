# Azure CLI を使用した BLOB ストレージのCRUD操作ガイド

## 目次
1. [Azure CLI のセットアップ](#azure-cli-のセットアップ)
2. [Azure へのログイン](#azure-へのログイン)
3. [事前準備：環境情報の確認](#事前準備環境情報の確認)
4. [Create（作成）- ファイルのアップロード](#create作成--ファイルのアップロード)
5. [Read（読み取り）- ファイルの一覧表示とダウンロード](#read読み取り--ファイルの一覧表示とダウンロード)
6. [Update（更新）- ファイルの上書きと更新](#update更新--ファイルの上書きと更新)
7. [Delete（削除）- ファイルの削除](#delete削除--ファイルの削除)
8. [便利なコマンド集](#便利なコマンド集)
9. [トラブルシューティング](#トラブルシューティング)

---

## Azure CLI のセットアップ

### 1. Azure CLI のインストール確認

Azure CLI がインストールされているか確認します：

```powershell
az --version
```

### 2. Azure CLI のインストール（未インストールの場合）

Windows の場合、以下のコマンドでインストールできます：

```powershell
# MSI インストーラーを使用する場合
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

または、公式サイトからダウンロード：
https://aka.ms/installazurecliwindows

### 3. インストール後の確認

```powershell
az --version
```

---

## Azure へのログイン

### 基本的なログイン

```powershell
az login
```

ブラウザが開き、Microsoft アカウントでログインします。

### サブスクリプションの確認

```powershell
# すべてのサブスクリプションを表示
az account list --output table

# 現在のサブスクリプションを表示
az account show --output table
```

### 特定のサブスクリプションを設定

```powershell
az account set --subscription "0d9ca316-2899-4a10-b81f-3c2cc3ed31f6"
```

---

## 事前準備：環境情報の確認

このプロジェクトで使用している環境情報：

```
リソースグループ名: rg-storage-demo
ストレージアカウント名: azuretrainingsekishirost
コンテナ名: uploads
リージョン: japaneast
```

### リソースの存在確認

```powershell
# リソースグループの確認
az group show --name rg-storage-demo --output table

# ストレージアカウントの確認
az storage account show --name azuretrainingsekishirost --resource-group rg-storage-demo --output table

# コンテナの確認
az storage container show --name uploads --account-name azuretrainingsekishirost --output table
```

### ストレージアカウントのキーを取得（後の操作で使用）

```powershell
# アカウントキーを取得
az storage account keys list --resource-group rg-storage-demo --account-name azuretrainingsekishirost --output table

# 環境変数に設定（PowerShell）
$env:AZURE_STORAGE_ACCOUNT = "azuretrainingsekishirost"
$env:AZURE_STORAGE_KEY = (az storage account keys list --resource-group rg-storage-demo --account-name azuretrainingsekishirost --query "[0].value" -o tsv)
```

**注意**: 環境変数を設定すると、以降のコマンドで `--account-name` や `--account-key` を省略できます。

---

## Create（作成）- ファイルのアップロード

### 1. 単一ファイルのアップロード

```powershell
# 基本的なアップロード
az storage blob upload `
  --account-name azuretrainingsekishirost `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt `
  --auth-mode key

# または、環境変数を設定済みの場合
az storage blob upload `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt
```

### 2. ファイル名を変更してアップロード

```powershell
az storage blob upload `
  --container-name uploads `
  --name documents/report-2025-11.txt `
  --file ./sample.txt
```

**ポイント**: `--name` でスラッシュを使用すると、仮想的なフォルダ構造を作成できます。

### 3. メタデータ付きでアップロード

```powershell
az storage blob upload `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt `
  --metadata author=Sekishi department=IT
```

### 4. コンテンツタイプを指定してアップロード

```powershell
az storage blob upload `
  --container-name uploads `
  --name image.jpg `
  --file ./image.jpg `
  --content-type "image/jpeg"
```

### 5. 複数ファイルの一括アップロード

```powershell
# ディレクトリ内のすべてのファイルをアップロード
az storage blob upload-batch `
  --destination uploads `
  --source ./local-folder `
  --account-name azuretrainingsekishirost
```

### 6. 上書き防止オプション

```powershell
# ファイルが存在する場合はエラーを返す
az storage blob upload `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt `
  --overwrite false
```

---

## Read（読み取り）- ファイルの一覧表示とダウンロード

### 1. コンテナ内のファイル一覧表示

```powershell
# シンプルな一覧表示
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --output table

# 詳細情報を表示
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --output json
```

### 2. プレフィックス（フォルダ）でフィルタリング

```powershell
az storage blob list `
  --container-name uploads `
  --prefix documents/ `
  --output table
```

### 3. ファイルのプロパティを表示

```powershell
az storage blob show `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost `
  --output json
```

### 4. 単一ファイルのダウンロード

```powershell
# 基本的なダウンロード
az storage blob download `
  --container-name uploads `
  --name myfile.txt `
  --file ./downloaded-file.txt `
  --account-name azuretrainingsekishirost

# 同じファイル名でダウンロード
az storage blob download `
  --container-name uploads `
  --name myfile.txt `
  --file ./myfile.txt
```

### 5. 複数ファイルの一括ダウンロード

```powershell
# コンテナ内のすべてのファイルをダウンロード
az storage blob download-batch `
  --destination ./downloads `
  --source uploads `
  --account-name azuretrainingsekishirost

# 特定のプレフィックスのファイルのみダウンロード
az storage blob download-batch `
  --destination ./downloads `
  --source uploads `
  --pattern "documents/*" `
  --account-name azuretrainingsekishirost
```

### 6. ファイルの内容を直接表示

```powershell
# テキストファイルの内容を表示
az storage blob download `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost `
  --no-progress | Out-String
```

### 7. ファイルのURL取得（SAS トークン付き）

```powershell
# 1時間有効なSASトークン付きURLを生成
az storage blob generate-sas `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost `
  --permissions r `
  --expiry (Get-Date).AddHours(1).ToString("yyyy-MM-ddTHH:mm:ssZ") `
  --https-only `
  --output tsv

# 完全なURLを生成
$sasToken = az storage blob generate-sas `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost `
  --permissions r `
  --expiry (Get-Date).AddHours(1).ToString("yyyy-MM-ddTHH:mm:ssZ") `
  --https-only `
  --output tsv

$blobUrl = "https://azuretrainingsekishirost.blob.core.windows.net/uploads/myfile.txt?$sasToken"
Write-Host $blobUrl
```

---

## Update（更新）- ファイルの上書きと更新

### 1. ファイルの上書きアップロード

```powershell
# デフォルトで上書きされます
az storage blob upload `
  --container-name uploads `
  --name myfile.txt `
  --file ./updated-sample.txt `
  --overwrite true
```

### 2. メタデータの更新

```powershell
# メタデータのみを更新
az storage blob metadata update `
  --container-name uploads `
  --name myfile.txt `
  --metadata version=2 updated="2025-11-01"
```

### 3. メタデータの表示

```powershell
az storage blob metadata show `
  --container-name uploads `
  --name myfile.txt
```

### 4. コンテンツタイプの更新

```powershell
az storage blob update `
  --container-name uploads `
  --name myfile.txt `
  --content-type "text/plain; charset=utf-8"
```

### 5. ファイルのコピー（同一アカウント内）

```powershell
# 同じコンテナ内でコピー
az storage blob copy start `
  --source-container uploads `
  --source-blob myfile.txt `
  --destination-container uploads `
  --destination-blob myfile-backup.txt `
  --account-name azuretrainingsekishirost

# 別のコンテナにコピー（コンテナが存在する場合）
az storage blob copy start `
  --source-container uploads `
  --source-blob myfile.txt `
  --destination-container backups `
  --destination-blob myfile.txt `
  --account-name azuretrainingsekishirost
```

### 6. ファイルの移動（コピー＋削除）

```powershell
# コピーしてから元のファイルを削除
az storage blob copy start `
  --source-container uploads `
  --source-blob old-location/myfile.txt `
  --destination-container uploads `
  --destination-blob new-location/myfile.txt `
  --account-name azuretrainingsekishirost

# コピーが完了したら元のファイルを削除
az storage blob delete `
  --container-name uploads `
  --name old-location/myfile.txt
```

---

## Delete（削除）- ファイルの削除

### 1. 単一ファイルの削除

```powershell
az storage blob delete `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost
```

### 2. 削除前の確認

```powershell
# ファイルが存在するか確認
az storage blob exists `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost

# 存在する場合のみ削除
$exists = az storage blob exists `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost `
  --query "exists" -o tsv

if ($exists -eq "true") {
    az storage blob delete `
      --container-name uploads `
      --name myfile.txt
    Write-Host "ファイルを削除しました"
} else {
    Write-Host "ファイルが存在しません"
}
```

### 3. 複数ファイルの一括削除

```powershell
# 特定のプレフィックスのファイルをすべて削除
az storage blob delete-batch `
  --source uploads `
  --pattern "temp/*" `
  --account-name azuretrainingsekishirost

# コンテナ内のすべてのファイルを削除（注意！）
az storage blob delete-batch `
  --source uploads `
  --account-name azuretrainingsekishirost
```

### 4. ソフト削除の有効化（誤削除対策）

```powershell
# ストレージアカウントでソフト削除を有効化（7日間保持）
az storage blob service-properties delete-policy update `
  --days-retained 7 `
  --account-name azuretrainingsekishirost `
  --enable true
```

### 5. 削除されたファイルの復元（ソフト削除が有効な場合）

```powershell
# 削除されたファイルを表示
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --include d `
  --output table

# 削除されたファイルを復元
az storage blob undelete `
  --container-name uploads `
  --name myfile.txt `
  --account-name azuretrainingsekishirost
```

---

## 便利なコマンド集

### 1. ファイルサイズの確認

```powershell
# すべてのファイルのサイズを表示
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --query "[].{Name:name, Size:properties.contentLength}" `
  --output table
```

### 2. 最近更新されたファイルの検索

```powershell
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --query "[].{Name:name, LastModified:properties.lastModified}" `
  --output table
```

### 3. ファイル数のカウント

```powershell
$count = (az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --query "length(@)") 

Write-Host "ファイル数: $count"
```

### 4. 特定の拡張子のファイルのみ表示

```powershell
az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --query "[?ends_with(name, '.txt')].name" `
  --output table
```

### 5. ストレージ使用量の確認

```powershell
# コンテナ内の合計サイズを計算
$totalSize = (az storage blob list `
  --container-name uploads `
  --account-name azuretrainingsekishirost `
  --query "sum([].properties.contentLength)") 

$totalSizeMB = [math]::Round($totalSize / 1MB, 2)
Write-Host "合計サイズ: $totalSizeMB MB"
```

### 6. コンテナの作成と削除

```powershell
# 新しいコンテナを作成
az storage container create `
  --name newcontainer `
  --account-name azuretrainingsekishirost `
  --public-access off

# コンテナを削除（すべてのファイルも削除されます）
az storage container delete `
  --name oldcontainer `
  --account-name azuretrainingsekishirost
```

### 7. パブリックアクセスの設定変更

```powershell
# コンテナをプライベートに設定
az storage container set-permission `
  --name uploads `
  --public-access off `
  --account-name azuretrainingsekishirost

# コンテナをパブリック読み取りに設定（blob レベル）
az storage container set-permission `
  --name uploads `
  --public-access blob `
  --account-name azuretrainingsekishirost
```

---

## トラブルシューティング

### エラー: "The specified resource does not exist"

**原因**: リソースグループ、ストレージアカウント、またはコンテナが存在しない

**解決策**:
```powershell
# Terraform で作成されたリソースを確認
terraform state list

# リソースが存在しない場合は再作成
terraform apply
```

### エラー: "Authentication failed"

**原因**: 認証情報が正しくない、またはログインしていない

**解決策**:
```powershell
# 再ログイン
az logout
az login

# サブスクリプションを確認
az account show

# 正しいサブスクリプションに設定
az account set --subscription "0d9ca316-2899-4a10-b81f-3c2cc3ed31f6"
```

### エラー: "Storage account key is required"

**原因**: 認証情報が設定されていない

**解決策**:
```powershell
# 環境変数を設定
$env:AZURE_STORAGE_ACCOUNT = "azuretrainingsekishirost"
$env:AZURE_STORAGE_KEY = (az storage account keys list --resource-group rg-storage-demo --account-name azuretrainingsekishirost --query "[0].value" -o tsv)

# または、コマンドに直接指定
az storage blob upload `
  --account-name azuretrainingsekishirost `
  --account-key "YOUR_ACCOUNT_KEY" `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt
```

### エラー: "The specified blob already exists"

**原因**: 上書き防止オプションが設定されている

**解決策**:
```powershell
# 上書きを許可
az storage blob upload `
  --container-name uploads `
  --name myfile.txt `
  --file ./sample.txt `
  --overwrite true
```

### パフォーマンスが遅い

**原因**: 大きなファイルまたは多数のファイル

**解決策**:
```powershell
# 並列アップロードを使用
az storage blob upload `
  --container-name uploads `
  --name largefile.zip `
  --file ./largefile.zip `
  --max-connections 4

# 一括操作にはバッチコマンドを使用
az storage blob upload-batch `
  --destination uploads `
  --source ./local-folder `
  --max-connections 4
```

### 環境変数がセッションをまたいで保持されない

**原因**: PowerShell の環境変数は現在のセッションのみ有効

**解決策**:
```powershell
# PowerShell プロファイルに追加（永続化）
notepad $PROFILE

# 以下を追加:
# $env:AZURE_STORAGE_ACCOUNT = "azuretrainingsekishirost"
# $env:AZURE_STORAGE_KEY = "YOUR_ACCOUNT_KEY"
```

---

## 実践例：完全なワークフロー

### シナリオ: レポートファイルの管理

```powershell
# 1. 環境変数の設定
$env:AZURE_STORAGE_ACCOUNT = "azuretrainingsekishirost"
$env:AZURE_STORAGE_KEY = (az storage account keys list --resource-group rg-storage-demo --account-name azuretrainingsekishirost --query "[0].value" -o tsv)

# 2. 新しいレポートをアップロード
az storage blob upload `
  --container-name uploads `
  --name reports/monthly-report-2025-11.txt `
  --file ./report.txt `
  --metadata department=IT author=Sekishi date=2025-11-01

# 3. アップロードされたことを確認
az storage blob list `
  --container-name uploads `
  --prefix reports/ `
  --output table

# 4. ファイルのプロパティを確認
az storage blob show `
  --container-name uploads `
  --name reports/monthly-report-2025-11.txt `
  --query "{Name:name, Size:properties.contentLength, Modified:properties.lastModified, Metadata:metadata}" `
  --output json

# 5. レポートを修正して再アップロード
az storage blob upload `
  --container-name uploads `
  --name reports/monthly-report-2025-11.txt `
  --file ./updated-report.txt `
  --overwrite true

# 6. 必要に応じてダウンロード
az storage blob download `
  --container-name uploads `
  --name reports/monthly-report-2025-11.txt `
  --file ./downloaded-report.txt

# 7. 古いレポートを削除
az storage blob delete `
  --container-name uploads `
  --name reports/monthly-report-2025-10.txt
```

---

## まとめ

このガイドでは、Azure CLI を使用した BLOB ストレージの基本的なCRUD操作を学びました：

- **Create**: `az storage blob upload` でファイルをアップロード
- **Read**: `az storage blob list` と `az storage blob download` でファイルを確認・ダウンロード
- **Update**: `az storage blob upload --overwrite` でファイルを更新
- **Delete**: `az storage blob delete` でファイルを削除

### 次のステップ

1. Azure Portal でストレージアカウントを確認し、CLI 操作の結果を視覚的に確認
2. スクリプトを作成して定期的なバックアップを自動化
3. SAS トークンを使用した安全なファイル共有を実装
4. Azure Storage Explorer などの GUI ツールと併用

### 参考リンク

- [Azure CLI 公式ドキュメント](https://docs.microsoft.com/ja-jp/cli/azure/)
- [Azure Storage CLI コマンドリファレンス](https://docs.microsoft.com/ja-jp/cli/azure/storage/blob)
- [Azure Storage のベストプラクティス](https://docs.microsoft.com/ja-jp/azure/storage/common/storage-best-practices)
