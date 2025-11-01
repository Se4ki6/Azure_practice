# sample.txt の作成手順

このファイルは、Terraform プロジェクトでストレージにアップロードするためのサンプルファイルです。

## 📝 ファイル作成方法

### PowerShell で作成する場合

```powershell
echo "Hello, Terraform!" > sample.txt
```

### コマンドプロンプトで作成する場合

```cmd
echo Hello, Terraform! > sample.txt
```

### メモ帳で作成する場合

1. メモ帳を開く
2. 以下の内容を入力：

```
Hello, Terraform!
This is a sample file for uploading to Azure Blob Storage.
Created: 2024-11-01
```

3. ファイル名を `sample.txt` として保存

## 📄 ファイルの内容

このサンプルファイルには以下のような内容を含めることができます：

```text
Hello, Terraform!

This is a sample file for uploading to Azure Blob Storage using Terraform.

Project: Azure Storage Demo
Created: 2024-11-01
Purpose: Learning Infrastructure as Code

Features demonstrated:
- Resource Group creation
- Storage Account provisioning
- Blob Container setup
- File upload automation

このファイルは Terraform によって自動的に Azure Blob Storage にアップロードされます。
```

## 🔧 使用方法

1. プロジェクトのルートディレクトリ（`main.tf`があるフォルダ）にこのファイルを配置
2. `terraform.tfvars`で`local_file_path = "./sample.txt"`が設定されていることを確認
3. `terraform apply`を実行するとファイルが自動的に Azure Blob Storage にアップロードされます

## 📋 注意事項

- ファイルのパスは`terraform.tfvars`の`local_file_path`変数で指定
- ファイルサイズは適度に小さく（数 KB 程度）
- 機密情報は含めない
- 文字エンコーディングは UTF-8 を推奨

このファイルを作成したら、[実行手順](./04-execution-guide.md)に従って Terraform を実行してください。
