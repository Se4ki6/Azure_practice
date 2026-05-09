# Phase 1 / Task 3: 基本コマンドとインフラのライフサイクル

## 目次

- [01-basic-commands.md](01-basic-commands.md) - init / fmt / validate / apply / state [done]
- [02-change-and-destroy.md](02-change-and-destroy.md) - インフラの変更と削除 [done]

## 振り返り（Phase 1 総合クイズ・10問）

回答は各問の `**回答**:` 行の下に記入してください。
全問記入後に `/learning-flow:grade` を実行すると採点・進捗更新を行います。

---

### Q1. 宣言的 IaC とは何か

Terraform を「宣言的 IaC」と呼ぶ理由を、命令的スクリプト（シェルスクリプト等）との違いを踏まえて説明してください。

**参考**:

- [What is Infrastructure as Code with Terraform?](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code)

**関連ノート**: [../task1/01-what-is-iac.md](../task1/01-what-is-iac.md)

**回答**:
Terraform側が勝手に差分を読んで差分のみ実行してくれるから

---

### Q2. プロバイダープラグインの動作

`terraform init` を実行すると何が起きるか。プロバイダープラグインのダウンロード先と、その後 `terraform apply` 時に Terraform がどうプラグインを使うかを説明してください。

**参考**:

- [Build infrastructure – Initialize the directory](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#initialize-the-directory)
- [Terraform Plugin Architecture](https://developer.hashicorp.com/terraform/plugin/how-terraform-works)

**関連ノート**: [reference/azurerm-provider-plugin-mechanism.md](../task1/reference/azurerm-provider-plugin-mechanism.md)

**回答**:
.terraform内にazurermというプロバイダーがダウンロードされる。terraform apply時に.tfstateを見てazurermがリソースを上げてくれる

---

### Q3. .terraform/ と .terraform.lock.hcl の Git 管理方針

`.terraform/` と `.terraform.lock.hcl` はそれぞれ Git に含めるべきか除外すべきか、理由とともに答えてください。

**参考**:

- [Build infrastructure – Initialize the directory](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#initialize-the-directory)

**関連ノート**: [../task3/01-basic-commands.md](01-basic-commands.md)

**回答**:
含めないべき、azurerm等のバイナリファイルが入っていて、バージョンの影響等やgitのストレージ問題からもinitして再ダウンロードしてもらうほうがいい

---

### Q4. terraform.tfstate のチーム共有問題

チーム開発で `terraform.tfstate` をローカルに置いたままにすると何が起きるか。問題点を 2 つ挙げ、解決策を答えてください。

**参考**:

- [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [azurerm Backend](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

**関連ノート**: [reference/tfstate-team-collaboration-problem.md](../task1/reference/tfstate-team-collaboration-problem.md)

**回答**:
前回実施分のキャッシュが残ってしまい、最新のリソース状況を.tfstateから読んでしまうから

---

### Q5. az login と Service Principal の使い分け

開発環境では `az login`、CI/CD では Service Principal を使い分ける理由を答えてください。

**参考**:

- [Build infrastructure – Authenticate using the Azure CLI](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli)
- [Create a Service Principal](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#create-a-service-principal)

**関連ノート**: [../task2/01-azure-auth.md](../task2/01-azure-auth.md)

**回答**:
az_loginはユーザーが絡む認証のため、terraform側が実行できない

---

### Q6. provider ブロックへの認証情報の直接記述を避ける理由

`provider "azurerm"` ブロックに `client_id` や `client_secret` を直接書かず、`ARM_*` 環境変数で渡すべき理由を答えてください。

**参考**:

- [Build infrastructure – Set your environment variables](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#set-your-environment-variables)

**関連ノート**: [../task2/01-azure-auth.md](../task2/01-azure-auth.md)

**回答**:
クライアント情報がgitに乗ってしまうことを防ぐため

---

### Q7. リソース参照構文の読み方

以下のコードの `azurerm_resource_group.rg.name` を構成する 3 つのパーツがそれぞれ何を指しているか答えてください。また、ハードコードより参照を使う利点を 2 つ挙げてください。

```hcl
resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.rg.name
}
```

**参考**:

- [Build infrastructure – Write configuration](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#write-configuration)
- [azurerm_resource_group – Attributes Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#attributes-reference)

**関連ノート**: [reference/terraform-resource-reference-syntax.md](../task2/reference/terraform-resource-reference-syntax.md)

**回答**:
リソースタイプ ローカル名　属性名、コードの汎用性を保つ、修正漏れを防ぐ

---

### Q8. terraform plan の出力記号

`terraform plan` の出力に現れる `+` / `~` / `-` / `-/+` の 4 つの記号がそれぞれ何を意味するか答えてください。また `-/+` になる典型的なケースを 1 つ挙げてください。

**参考**:

- [Change infrastructure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-change)

**関連ノート**: [01-basic-commands.md](01-basic-commands.md)

**回答**:
新規作成、更新、 削除、 削除して再作成

---

### Q9. terraform destroy の削除順序

以下のリソースが定義されているとき、`terraform destroy` はどの順序で削除するか。またその順序はどのように決まるか答えてください。

```
Resource Group → Storage Account → Blob Container
（Storage Account は Resource Group に依存、Blob Container は Storage Account に依存）
```

**参考**:

- [Destroy infrastructure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-destroy)

**関連ノート**: [02-change-and-destroy.md](02-change-and-destroy.md)

**回答**:
Blob Container→Storage Account→Resource Group、依存関係の逆順

---

### Q10. features {} が必要な理由

`provider "azurerm"` ブロックには空でも `features {}` を書かなければなりません。省略するとどうなりますか？また、`azurerm` 以外のプロバイダー（例: `aws`）にも同じ要件がありますか？

**参考**:

- [AzureRM Provider – features block](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features)

**関連ノート**: [../task2/02-provider-config.md](../task2/02-provider-config.md)

**回答**:
動かなくなる。azurermを動かすうえではからでも必要、aws側にもある？
