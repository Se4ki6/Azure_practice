---
name: bicep-orchestrator
description: Bicep で Azure リソースを「企画から段階的に」作るときの指揮役スキル。インタビュー → 計画ファイル作成 → 計画の確認・修正 → コーディング（bicep-coder agent へ委譲）→ レビュー（bicep-reviewer agent へ委譲）→ What-if 提示 までの一連のワークフローを、このプロジェクトの学習フロー（解説→確認→実装）に沿って進行管理する。`/bicep-orchestrator` で明示起動する。単発の1リソース追記やレビューだけなら、このワークフローを通さず通常の編集（必要なら bicep-coder / bicep-reviewer agent に委譲）で対応する。
---

このスキルは、Bicep で **複数リソースを企画段階からまとめて作る** ときの **指揮役（オーケストレータ）**。
自分でコードやレビュー知識を持つのではなく、**順番・人間ゲート・受け渡し（計画ファイル）だけ**を管理し、重い作業は subagent に委譲する「薄い指揮者」に徹する。

## いつ使うか / 使わないか

- **使う**: ある程度まとまった構成（複数リソース・モジュール群）を、何を作るか決めるところから企画して作りたいとき。`/bicep-orchestrator` で明示起動。
- **使わない**: 既存 `.bicep` への1リソース追記、レビューだけ、書き方の質問 → このワークフローを通さず通常の編集で対応する（重い生成なら **bicep-coder agent**、レビューだけなら **bicep-reviewer agent** に直接委譲してよい）。

## 最重要：このワークフローの思想

このプロジェクトの最重要ルールは **解説→確認→実装（勝手に進めない）**。全自動パイプラインはこれと衝突する。
そこでこのワークフローは「全自動」ではなく **人間ゲート付きパイプライン** として動く。鍵は次の一点：

> **計画ファイル＝contract（受け渡し仕様）兼 確認ゲート。**
> 解説と確認は「計画承認」までに前倒しで全部済ませる。計画が承認された時点で 解説→確認 は完了しているので、その後 subagent に一気に実装させても原則を破らない。

人間ゲートは **計画承認の1箇所に集約** する（各ステージ後の逐一確認はしない）。例外は **デプロイ（`az deployment ... create`）だけは常に別途明示許可** を取る。

## ワークフロー

```
1. インタビュー        (main・対話的)   何を作りたいか聞く
2. 計画ファイル作成     (main・対話的)   plans/ に固定スキーマで書く / 対象ディレクトリも決める
3. 計画の確認・修正     (main・対話的)   ユーザーと往復して計画を仕上げる
   ─────── ★計画承認（唯一の重い人間ゲート）───────
4. コーディング        (bicep-coder agent へ委譲・隔離)  承認済み計画を一気に実装
5. レビュー            (bicep-reviewer agent へ委譲・隔離) 読み取り専用で所見を返す
6. 所見の提示と修正判断  (main・対話的)   所見を全文提示 → 直す/このまま をユーザーが判断（直すなら4へ1ラウンド戻す）
7. What-if 提示        (main)          orchestrator が実行し全文提示（az auth 無ければ build にフォールバック）
```

### 1. インタビュー

何を作りたいかを聞き出す。最低限そろえる：
- 作りたいもの・ゴール（例: Blob ストレージ + 監視一式）
- 含めるリソース種別のあたり（曖昧でよい。計画段階で確定させる）
- 環境・命名 prefix（既存 Terraform 構成に合わせるか）
- **対象ディレクトリ**（学習モノレポなので、どこに作るかは重要。既存 `Functions/infra/` の Terraform 構成と1対1で揃える方針を基本にする）

### 2. 計画ファイル作成

`plans/<topic>-bicep-plan.md` に、**下記の固定スキーマ**で書く。subagent が確実に消費できるよう、項目を省略しない（決まっていない項目は「未解決の質問」へ）。

```markdown
# <タイトル> Bicep Plan

## 目的
<何を・なぜ作るか。1〜3行>

## 対象ディレクトリ
<例: Functions/infra-bicep/  既存 Terraform 構成との対応も書く>

## リソース一覧
| リソース | 種別 (Microsoft.*) | apiVersion | 役割 |
|---|---|---|---|
| ... | ... | <docsで裏取り> | ... |

## 命名
<CAF 略語 + {prefix}-{env}、uniqueString suffix の方針。Terraform 側 locals と揃える>

## パラメータ
<param に出す環境差分。@description/@allowed 等の制約方針>

## セキュリティ既定値
<TLS1_2 / allowBlobPublicAccess:false / publicAccess:'None' など、明示的に確認した既定値>

## モジュール分割
<infra/modules/*.bicep の切り出し。main.bicep からの module 呼び出し構成。Terraform modules/ と1対1>

## What-if スコープ
<対象 resource group / subscription、targetScope、.bicepparam の有無>

## 未解決の質問
<計画承認前に決めきれていない点。ここが空になるまで承認に進まない>
```

設計判断（なぜこの apiVersion / なぜこのモジュール分割か）は **この計画ファイルに集約** する。純粋な学習Q&A（概念の深掘り）は既存 learning-flow（reference）に任せ、ここで学習フローを再発明しない。

### 3. 計画の確認・修正

計画をユーザーに提示し、往復で仕上げる。「未解決の質問」が空になったら承認を求める。
apiVersion・リソース種別など一次情報が要る箇所は記憶で書かず **use-tavily / 公式 docs で裏取り**（`https://learn.microsoft.com/azure/templates/`）。

### ★計画承認

ユーザーが明示的に「この計画で進めて」と言うまで 4 に進まない。**ここが唯一の重い確認ゲート。**

### 4. コーディング（bicep-coder agent へ委譲）

承認済み計画を **subagent `bicep-coder`**（`.claude/agents/bicep-coder.md`）に渡して一気に実装させる。
委譲時のプロンプトに必ず含める：
- 承認済み計画ファイルのパス（`plans/...`）を「これに従え」と明示
- 対象ディレクトリ
- 規約は `.claude/rules/bicep-conventions.md` に従うこと（命名・タグ・セキュリティ既定値）
- **デプロイ禁止**（`az deployment ... create` は実行しない。build / what-if まで）

agent は生成ファイル一覧・各役割・裏取りした点・what-if コマンドを要約して返す。

### 5. レビュー（bicep-reviewer agent へ委譲）

生成物を **subagent `bicep-reviewer`**（`.claude/agents/bicep-reviewer.md`、読み取り専用）に渡す。
委譲時のプロンプトに必ず含める：
- レビュー対象ファイル群のパス
- 承認済み計画ファイルのパス（計画通りに実装されているかの照合に使う）
- reviewer は **書き換えない**。所見（深刻度つき）だけを返す

### 6. 所見の提示と修正判断（修正ループ）

reviewer の所見を **全文ユーザーに提示** し、「直す / このまま行く」をユーザーに判断してもらう。
- 「直す」→ 所見を添えて **bicep-coder agent に再委譲（1ラウンド）**。修正後に必要なら再レビュー。
- 「このまま」→ 7 へ。
無限ループにはしない。舵は常にユーザーが握る。

### 7. What-if 提示

**orchestrator が main 文脈で実行し、出力を全文提示** する。

```powershell
# まず構文・lint（オフラインでも可。これは常に通す）
az bicep build --file <plan の対象>/main.bicep

# 差分プレビュー（az auth + 対象スコープがある場合）
az deployment group what-if `
  --resource-group <rg-name> `
  --template-file <...>/main.bicep `
  --parameters <...>/main.bicepparam
```

- **az auth / 対象スコープが無ければ** `az bicep build`（構文・lint・ARM トランスパイル）に **フォールバック** し、what-if は「auth 後に実行するコマンド」として提示する。
- **デプロイは絶対に自動でしない。** `az deployment ... create` はユーザーの明示許可を都度取る。

## 進行管理のヒント

- 複数ターンにまたがるので、`TodoWrite` で「今どのステージか」をユーザーに可視化すると迷子になりにくい。
- 各 subagent への委譲は1メッセージ1委譲を基本にし、戻ってきた要約を main で噛み砕いてユーザーに伝える。

## 参照

- コーディング委譲先（subagent）: `.claude/agents/bicep-coder.md`
- レビュー委譲先（subagent）: `.claude/agents/bicep-reviewer.md`
- 規約（コピペせず参照・全コンポーネント共通）: `.claude/rules/bicep-conventions.md`
- main.bicep / モジュール雛形: `.claude/rules/bicep-templates.md`
- 公式 docs 調査: `use-tavily` スキル
- 計画ファイル置き場: `plans/`
- 既存 Terraform 構成（設計の元）: `Functions/infra/`
