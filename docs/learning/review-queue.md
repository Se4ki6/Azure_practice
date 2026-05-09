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

## 習得済み

<!-- 再出題で正解した問題をここに移動（日付更新） -->
