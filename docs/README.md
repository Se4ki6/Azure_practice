# Azure Storage Account Terraform プロジェクト

## 📋 概要

このプロジェクトは、**Terraform**を使って**Azure**上にストレージアカウントを自動構築するインフラ初学者向けのサンプルです。

## 🎯 学習目標

- Azure の基本概念を理解する
- Terraform の基本的な使い方を覚える
- Infrastructure as Code (IaC) の考え方を身につける

## 📁 ドキュメント構成

- [Azure 基礎知識](./01-azure-basics.md) - Azure の基本概念と用語
- [Terraform 基礎知識](./02-terraform-basics.md) - Terraform の概要と仕組み
- [ファイル構成解説](./03-file-structure.md) - 各ファイルの役割と内容
- [実行手順](./04-execution-guide.md) - プロジェクトの実行方法
- [注意事項とベストプラクティス](./05-best-practices.md) - セキュリティと運用のポイント

## 🚀 クイックスタート

1. [Azure 基礎知識](./01-azure-basics.md)を読んで Azure の概念を理解
2. [Terraform 基礎知識](./02-terraform-basics.md)で Terraform の仕組みを学習
3. [ファイル構成解説](./03-file-structure.md)で各ファイルの役割を確認
4. [実行手順](./04-execution-guide.md)に従ってプロジェクトを実行

## 📊 作成されるリソース

このプロジェクトを実行すると、以下の Azure リソースが作成されます：

- **リソースグループ**: `rg-storage-demo`
- **ストレージアカウント**: `azuretrainingyokoyamast`
- **Blob コンテナ**: `files`
- **Blob ファイル**: ローカルファイルのアップロード

## ⚠️ 重要な注意事項

- このプロジェクトを実行すると**Azure 利用料金が発生**します
- 学習が終わったら必ず `terraform destroy` でリソースを削除してください
- `terraform.tfvars` ファイルには機密情報が含まれるため、Git 管理から除外してください

## 📞 サポート

各ドキュメントファイルで詳細な説明を確認できます。分からないことがあれば、まず該当するドキュメントを読んでみてください。
