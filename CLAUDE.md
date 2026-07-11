# Azure - プロジェクトコンテキスト

## 目的

Azure を学ぶために、**実際に Azure リソースを立てて動かす**ことを軸にしたプロジェクト。
リソースは **Terraform または Bicep のどちらで書くかを、その都度ユーザーが選んで**構築する。
両 IaC ツールを使い分けながら、Azure の主要リソースと各ツールの設計思想を理解していく。
コードを完成させること自体ではなく、各概念の理解とリソースの実構築が目的。

## 最重要ルール

- **勝手に実装を進めない**: 各ステップで 解説 → ユーザー確認 → 実装 の順を守る
- **どちらの IaC で書くかはユーザーが決める**: Terraform / Bicep を勝手に選ばない。未指定なら確認する
- **勝手に外向き・不可逆な操作をしない**: デプロイ（`terraform apply` /
  `az deployment ... create`）は必ずユーザーの明示許可を取る。`plan` / `what-if` までは確認用に提案してよい
- **質疑応答は docs に残す**: リソースごとに `docs/{リソース名}/` を作り、解説・Q&A を
  トピック別 md で記録する（Web ソース付きの深掘り情報は `reference/` に分離）

## 作業の入口（どう進めるか）

- **Bicep でリソースを企画から作る**: `/bicep-orchestrator`
  （インタビュー → 計画 → 実装は bicep-coder agent、レビューは bicep-reviewer agent に委譲）
- **Terraform でリソースを作る**: 既存構成 `resources/functions/infra-terraform/` をベースに編集
- **IaC 共通の規約・雛形**: `.claude/rules/`（`bicep-conventions.md` / `bicep-templates.md`）

## ドキュメント構成

- `resources/{リソース名}/` — リソースごとの実装（`infra-terraform/` / `infra-bicep/` / `app/` 等）
- `plans/` — 実装計画
- `docs/{リソース名}/` — リソースごとの解説・Q&A（深掘りは `reference/` に分離）
- `zenn/plan/` `zenn/publish/` — Zenn 記事の構成案・下書き（`zenn` スキル参照）
- `.claude/rules/` — IaC 共通の規約・雛形
