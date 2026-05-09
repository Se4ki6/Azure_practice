<!-- 復習キュー: 学習セッション開始時に「待機中」を確認・再出題する。
正解した問題は「習得済み」セクションに移動。 -->

# 復習キュー

## 待機中

### [2026-05-09] Phase 1 / Task 1〜3 — Q1 宣言的 IaC の定義

**問題**: Terraform を「宣言的 IaC」と呼ぶ理由を、命令的スクリプトとの違いを踏まえて説明せよ。
**当時の回答**: Terraform側が勝手に差分を読んで差分のみ実行してくれるから
**模範解答の要点**:
- 宣言的 = 「あるべき姿（What）」を書く。命令的 = 「手順（How）」を書く
- 差分計算は結果であって、宣言的の定義ではない
- 「こうあってほしい」を書くだけで、Terraform が差分・順序をすべて担う
**参考**:
- [What is Infrastructure as Code with Terraform?](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/infrastructure-as-code)
**関連ノート**: [docs/learning/phase1/task1/01-what-is-iac.md](docs/learning/phase1/task1/01-what-is-iac.md)

---

### [2026-05-09] Phase 1 / Task 1〜3 — Q2 apply 時の Terraform コアと azurerm の役割分担

**問題**: terraform init のダウンロード先と、apply 時に Terraform がどうプラグインを使うかを説明せよ。
**当時の回答**: .terraform内にazurermがダウンロードされる。apply時に.tfstateを見てazurermがリソースを上げてくれる
**模範解答の要点**:
- .tfstate を読むのは Terraform コア。azurerm は「API を叩く役割」のみ
- Terraform コアが差分を計算 → azurerm に「このリソースを作れ」と指示 → azurerm が Azure API を呼ぶ
**参考**:
- [Terraform Plugin Architecture](https://developer.hashicorp.com/terraform/plugin/how-terraform-works)
- [Build infrastructure – Initialize the directory](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#initialize-the-directory)
**関連ノート**: [docs/learning/phase1/task1/reference/azurerm-provider-plugin-mechanism.md](docs/learning/phase1/task1/reference/azurerm-provider-plugin-mechanism.md)

---

### [2026-05-09] Phase 1 / Task 1〜3 — Q3 .terraform.lock.hcl は Git に含める

**問題**: .terraform/ と .terraform.lock.hcl はそれぞれ Git に含めるべきか除外すべきか。
**当時の回答**: 含めないべき（バイナリのため）→ .terraform.lock.hcl への言及なし
**模範解答の要点**:
- `.terraform/` → 除外（バイナリ・OS 依存）
- `.terraform.lock.hcl` → **含める**（チームで同一プロバイダーバージョンを使うためのロックファイル）
**参考**:
- [Build infrastructure – Initialize the directory](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#initialize-the-directory)
**関連ノート**: [docs/learning/phase1/task3/01-basic-commands.md](docs/learning/phase1/task3/01-basic-commands.md)

---

### [2026-05-09] Phase 1 / Task 1〜3 — Q4 tfstate ローカル運用の問題点とRemote Backend

**問題**: チーム開発で terraform.tfstate をローカルに置いたままにすると何が起きるか。問題点を 2 つと解決策を答えよ。
**当時の回答**: 前回実施分のキャッシュが残ってしまい、最新のリソース状況を.tfstateから読んでしまうから（個人の問題にとどまっており、チーム間の整合性問題に言及なし）
**模範解答の要点**:
- 問題①: 開発者ごとに異なる .tfstate を持つ → 誰の .tfstate が「正」か分からなくなる
- 問題②: ロック機構がないため同時 apply で二重作成・競合が起きる
- 解決策: Remote Backend（Azure Blob に .tfstate を置いて共有 + State Lock）
**参考**:
- [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [azurerm Backend](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)
**関連ノート**: [docs/learning/phase1/task1/reference/tfstate-team-collaboration-problem.md](docs/learning/phase1/task1/reference/tfstate-team-collaboration-problem.md)

---

### [2026-05-09] Phase 1 / Task 1〜3 — Q8 -/+ になる典型的なケース

**問題**: plan 出力の 4 記号の意味と、-/+ になる典型例を 1 つ挙げよ。
**当時の回答**: 記号の意味は正解。典型例が未回答
**模範解答の要点**:
- `-/+` = 削除して再作成。変更不可な属性（Storage Account の name 等）を変えると発生する
- 名前変更は「新しいリソースを作って古いを消す」ことになるため -/+ になる
**参考**:
- [Change infrastructure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-change)
**関連ノート**: [docs/learning/phase1/task3/01-basic-commands.md](docs/learning/phase1/task3/01-basic-commands.md)

---

### [2026-05-09] Phase 1 / Task 1〜3 — Q10 features {} は azurerm 固有の要件

**問題**: features {} を省略するとどうなるか。aws プロバイダーにも同じ要件があるか。
**当時の回答**: 動かなくなる（正解）。aws側にもある？（不確か）
**模範解答の要点**:
- 省略するとエラーになる（正解）
- `features {}` は `azurerm` 固有の要件。`aws` プロバイダーには不要
- プロバイダーごとに設計が異なるため、使うプロバイダーのドキュメントを確認する習慣をつける
**参考**:
- [AzureRM Provider – features block](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features)
**関連ノート**: [docs/learning/phase1/task2/02-provider-config.md](docs/learning/phase1/task2/02-provider-config.md)

---

### [2026-05-09] Phase 2 / Task 1 — Q3 `storage_account_id` を使うべき理由

**問題**: `storage_account_name`（旧）ではなく `storage_account_id`（新）を使うべき理由を2つ説明せよ。また使い続けるとどうなるか。
**当時の回答**: ここわかっていない
**模範解答の要点**:
- ① 非推奨（Deprecated）のため将来のバージョンで削除される
- ② `storage_account_id` を使うと Terraform が明示的な依存関係を認識し、SA → Container の作成順を自動解決する
- 使い続けると将来の provider アップグレード時に突然 apply が壊れる
**参考**:
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
**関連ノート**: [docs/learning/phase2/task1/03-storage-container.md](docs/learning/phase2/task1/03-storage-container.md)

---

### [2026-05-09] Phase 2 / Task 1 — Q4 `container_access_type` の `container` の意味

**問題**: `container_access_type` の `private` / `blob` / `container` の違いを説明し、どれを選ぶべきか答えよ。
**当時の回答**: private は制限あり、blob はURL閲覧可能、container は不明
**模範解答の要点**:
- `private`: 認証済みユーザーのみ
- `blob`: URL を知っていれば匿名でファイルを読める
- `container`: ファイルの匿名読み取り + コンテナ内ファイル一覧も匿名取得可能
- 学習・本番問わず `private` が推奨
**参考**:
- [azurerm_storage_container — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
**関連ノート**: [docs/learning/phase2/task1/03-storage-container.md](docs/learning/phase2/task1/03-storage-container.md)

---

### [2026-05-09] Phase 2 / Task 1 — Q5 `primary_access_key` を output する際の設定

**問題**: `primary_access_key` を output で出力するとき何を設定すべきか。忘れるとどうなるか。
**当時の回答**: キーが露出してしまう（正解）。設定すべき項目（sensitive = true）への言及なし
**模範解答の要点**:
- `sensitive = true` を output ブロックに付ける
- 付け忘れると terraform plan/apply の CLIログにキーが平文で出力される
**参考**:
- [azurerm_storage_account — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
**関連ノート**: [docs/learning/phase2/task1/02-storage-account.md](docs/learning/phase2/task1/02-storage-account.md)

---

### [2026-05-09] Phase 2 / Task 1 — Q6 Resource Group と .sln の相違点（RBAC・コスト管理）

**問題**: Resource Group と C# .sln の共通点と異なる点（3つ）を説明せよ。
**当時の回答**: 削除の連鎖の違いのみ正解。RBAC・コスト管理の違いが未回答
**模範解答の要点**:
- 共通点: 複数のものを一まとめにする入れ物構造
- 相違① 削除: .sln を消してもプロジェクトは残る。RG を消すと中のリソースが全部消える
- 相違② RBAC: RG 単位でアクセス権限を設定できる（.sln にはない）
- 相違③ コスト管理: RG 単位でコストを集計・分析できる（.sln にはない）
**参考**:
- [Azure Resource Group とは — Microsoft Docs](https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/management/manage-resource-groups-portal)
**関連ノート**: [docs/learning/phase2/task1/reference/resource-group-vs-csharp-sln.md](docs/learning/phase2/task1/reference/resource-group-vs-csharp-sln.md)

---

## 習得済み

<!-- 再出題で正解した問題をここに移動（日付更新） -->
