# Azure — 学習コンテキスト

## プロジェクトの目的

Azure × Terraform の学習が主目的。Blob ストレージ + 基本インフラ一式 を構築する過程で、Azure × Terraform を段階的に学ぶ。コード完成が目的ではなく、各概念の理解が最優先。

## Phase構成（全 5 Phase）

各Phaseで新規概念を1-2個ずつ導入し、じっくり学ぶ。

| Phase | テーマ | 新規概念 | 状態 |
|---|---|---|---|
| Phase 1 | Terraform × Azure 基礎 | プロバイダー設定・認証・init/plan/apply | **完了** |
| Phase 2 | Azure コアリソース | Resource Group / Storage Account / Blob Container | **進行中** |
| Phase 3 | 変数・モジュール化 | variables / locals / modules | 未着手 |
| Phase 4 | 状態管理（Remote Backend） | terraform.tfstate を Azure Blob で管理 | 未着手 |
| Phase 5 | セキュリティ・運用 | RBAC / ネットワーク制御 / タグ管理 | 未着手 |

設計書: `plans/azure-terraform-learning-phases-design.md`

## 現在の進捗

**Phase 2 / Task 1**: Azure コアリソース（Resource Group / Storage Account / Blob Container）の学習段階。

## タスクごとの学習フロー

各タスクで以下のサイクルを回す:

1. **解説**: 何をするか、なぜそうするか、設計思想やベストプラクティスとの関連
2. **確認**: ユーザーが理解したか確認、質問があれば回答
3. **実装**: ユーザーの「進めて」を受けてから実行
4. **振り返り**: 生成されたコードの解説、注目ポイント、疑問の議論
5. **次へ**: ユーザーの「次に進む」を受けてから次のタスクへ

**重要: 勝手に進めない。** 各ステップでユーザーの確認を取る。

## ドキュメント構成ルール

### 学習ノート

```
docs/learning/phase{N}/task{M}/
├── main.md                     ← 目次 + 振り返り
├── 01-{トピック名}.md           ← トピック別の解説・Q&A
├── 02-{トピック名}.md
└── reference/
    ├── {テーマ}-{詳細}.md       ← Web検索を含む詳細リファレンス
    └── ...
```

### ルール

- **大枠ごとにmdを分ける**（1つのmdにすべてを入れない）
- **referenceは深掘り用**: Web検索のソース付き、詳細な比較表、具体例
- **トピックmdはQ&A中心**: 解説 + 質疑応答の記録
- **main.mdは目次**: トピックmdとreferenceへのリンク + 振り返り
- **コードにもコメント**: 該当コードの上に1行の説明 + docsへのリンク

## 関連ドキュメントの場所

| ドキュメント | パス |
|---|---|
| Phase設計書 | `plans/azure-terraform-learning-phases-design.md` |

---

_Generated at 2026-05-09 by learning-flow plugin_
