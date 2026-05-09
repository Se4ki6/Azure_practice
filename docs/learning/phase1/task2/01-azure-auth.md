# Azure 認証（az login / Service Principal）

> 出典: [Build infrastructure – Authenticate using the Azure CLI](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli)（閲覧日 2026-05-09）
> このノートは公式ドキュメントの「Azure Get Started > Build infrastructure」の認証セクションを起点に、Claudeが自動生成した教材です。

## 概要

Terraform が Azure を操作するには認証情報が必要。開発環境では Azure CLI (`az login`) を使う方法が最もシンプル。CI/CD や自動化環境では Service Principal（サービスプリンシパル）を使う。

## 公式docsに沿った解説

### Prerequisites（前提条件）

- Azure サブスクリプション（無料試用版でも可）
- Terraform 1.2.0 以上
- Azure CLI のインストール

Azure CLI のインストール確認：

```shell
az version
```

### Authenticate using the Azure CLI（Azure CLI での認証）

```shell
az login
```

ブラウザが開き、Azureアカウントでログインする。複数サブスクリプションがある場合は使用するサブスクリプションを指定：

```shell
az account set --subscription "<SUBSCRIPTION_ID>"
```

現在のサブスクリプション確認：

```shell
az account show
```

### Create a Service Principal（サービスプリンシパルの作成）

自動化・CI/CD 環境では Service Principal（SP）を使う。SP はアプリケーションや自動化ツール用の「専用 ID」。

```shell
az ad sp create-for-rbac \
  --role="Contributor" \
  --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

出力例：

```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "azure-cli-2024-xx-xx",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### Set your environment variables（環境変数の設定）

SP の情報を環境変数にセットすると Terraform が自動的に読み込む：

```powershell
# Windows PowerShell
$env:ARM_CLIENT_ID     = "<appId>"
$env:ARM_CLIENT_SECRET = "<password>"
$env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$env:ARM_TENANT_ID    = "<tenant>"
```

```shell
# macOS / Linux
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<tenant>"
```

## 重要ポイント

- **開発環境**: `az login` が最もシンプル（Terraform が CLI の認証情報を自動利用）
- **CI/CD・自動化**: Service Principal + 環境変数 `ARM_*` を使う
- `--role="Contributor"` = サブスクリプション内でリソース作成・削除が可能
- `ARM_*` 環境変数は Terraform の `azurerm` プロバイダーが自動的に読み込む

## 関連

- 議論・Q&A: [reference/az-login-mfa-no-subscription-troubleshoot.md](reference/az-login-mfa-no-subscription-troubleshoot.md)
- 次の教材: [02-provider-config.md](02-provider-config.md)

---

_Auto-generated at 2026-05-09 via /learning-flow:material（公式docs駆動）_
