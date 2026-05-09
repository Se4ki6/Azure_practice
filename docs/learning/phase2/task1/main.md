# Phase 2 / Task 1: Azure コアリソース（Resource Group / Storage Account / Blob Container）

## 目次

- [01-resource-group.md](01-resource-group.md) - azurerm_resource_group — リソースグループの定義 [done]
- [02-storage-account.md](02-storage-account.md) - azurerm_storage_account — ストレージアカウントの定義 [done]
- [03-storage-container.md](03-storage-container.md) - azurerm_storage_container — Blob コンテナの定義 [done]

## 振り返り（クイズ形式）

回答は各問の `**回答**:` 行の下に記入してください。
全問記入後に `/learning-flow:grade` を実行すると、Claudeが採点して進捗を更新します。

---

### Q1. Resource Group を削除したとき、中のリソースはどうなるか？

`terraform destroy` で `azurerm_resource_group` を削除した場合、同じ Resource Group に属する Storage Account や Blob Container はどうなりますか？理由も含めて説明してください。

**参考**:
- [azurerm_resource_group — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [Azure Resource Group とは — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/management/manage-resource-groups-portal)

**関連ノート**: [01-resource-group.md](01-resource-group.md)

**回答**:

---

### Q2. Storage Account の名前がグローバル一意である理由

`azurerm_storage_account` の `name` はなぜ「グローバルで一意」である必要があるのか説明してください。（ヒント: エンドポイントの URL を考えてみてください）

**参考**:
- [azurerm_storage_account — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

**関連ノート**: [02-storage-account.md](02-storage-account.md)

**回答**:

---

### Q3. `storage_account_name` ではなく `storage_account_id` を使うべき理由

`azurerm_storage_container` には `storage_account_name`（旧）と `storage_account_id`（新）の2つの引数があります。なぜ `storage_account_id` の使用が推奨されているのか説明してください。また、`storage_account_name` を使い続けるとどうなりますか？

**参考**:
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

**関連ノート**: [03-storage-container.md](03-storage-container.md)

**回答**:

---

### Q4. `container_access_type` の選択肢と使い分け

`container_access_type` には `private` / `blob` / `container` の 3 つがあります。それぞれどのような違いがあるか説明し、学習・本番環境でどれを選ぶべきか理由とともに答えてください。

**参考**:
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

**関連ノート**: [03-storage-container.md](03-storage-container.md)

**回答**:

---

### Q5. `primary_access_key` を output で出力する際の注意点

Storage Account の `primary_access_key` を Terraform の `output` ブロックで出力する場合、何を設定しなければなりませんか？それを忘れるとどうなりますか？

**参考**:
- [azurerm_storage_account — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

**関連ノート**: [02-storage-account.md](02-storage-account.md)

**回答**:

---

### Q6. Resource Group と C# の .sln の共通点・相違点

「Resource Group は C# の .sln ファイルに似ている」という類比について、共通している点と異なる点をそれぞれ挙げて説明してください（異なる点は 3 つ）。

**参考**:
- [Azure Resource Group とは — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/management/manage-resource-groups-portal)

**関連ノート**: [reference/resource-group-vs-csharp-sln.md](reference/resource-group-vs-csharp-sln.md)

**回答**:

---

### Q7. Azure ストレージサービスと AWS の対応

Azure の Blob / File / Queue / Table それぞれが AWS のどのサービスに相当するか、用途とあわせて答えてください。

**参考**:
- [Azure Blob Storage とは — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/storage/blobs/storage-blobs-introduction)
- [Azure ストレージの概要 — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/storage/common/storage-introduction)

**関連ノート**: [reference/azure-storage-types-vs-aws.md](reference/azure-storage-types-vs-aws.md)

**回答**:

---

### Q8. LRS と GRS の違いと選び方

`account_replication_type = "LRS"` と `"GRS"` の違いを説明してください。学習環境では LRS が推奨される理由と、本番環境で GRS を選ぶべきケースも答えてください。

**参考**:
- [Azure Storage の冗長性 — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/storage/common/storage-redundancy)

**関連ノート**: [reference/storage-replication-types.md](reference/storage-replication-types.md)

**回答**:

---

### Q9. AWS S3 と Azure Blob で Terraform のリソース定義数が異なる理由

AWS S3 バケットを Terraform で作る場合と Azure Blob Container を作る場合とで、必要な `resource` ブロック数が異なります。Azure の方が多くなる理由を構造的に説明してください。

**参考**:
- [aws_s3_bucket — Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

**関連ノート**: [reference/s3-vs-blob-terraform-comparison.md](reference/s3-vs-blob-terraform-comparison.md)

**回答**:
