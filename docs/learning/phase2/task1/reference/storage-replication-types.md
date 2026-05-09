# Storage Account の冗長化方式（LRS / ZRS / GRS / RAGRS）

> 種別: ユーザー議論・Q&A の記録（Phase 2 / Task 1）
> 関連教材: [02-storage-account.md](../02-storage-account.md)

## 論点

`account_replication_type = "LRS"` の LRS が何を意味するのか、他の選択肢との違いを知りたかった。

## Q&A

**Q1: LRS ってなに？**

LRS = Locally Redundant Storage（ローカル冗長ストレージ）。同じデータセンター内に 3 つのコピーを作って保存する方式。

```
データセンター（Japan East）
├── コピー 1
├── コピー 2
└── コピー 3
```

## 比較表

| 値 | 正式名称 | 範囲 | 特徴 | 用途 |
|---|---|---|---|---|
| `LRS` | ローカル冗長 | 同一データセンター | 最安価 | **学習・開発環境** |
| `ZRS` | ゾーン冗長 | 同リージョン・3ゾーン | データセンター障害に強い | 可用性が必要な場合 |
| `GRS` | 地理冗長 | LRS + 別リージョン複製 | 地域障害に強い。障害時は読み取り不可 | 災害対策が必要な本番 |
| `RAGRS` | 読み取りアクセス地理冗長 | GRS + 別リージョン読み取り可 | 高可用性 | 読み取りも分散したい本番 |
| `GZRS` | 地理ゾーン冗長 | ZRS + 別リージョン複製 | ZRS の地理冗長版 | 高可用性 + 災害対策 |
| `RAGZRS` | 読み取りアクセス地理ゾーン冗長 | GZRS + 別リージョン読み取り可 | 最も高可用 | ミッションクリティカルな本番 |

## 結論 / 整理

- 学習・開発環境は `LRS` 一択（最安価）
- 本番は SLA 要件に応じて選ぶ。迷ったら `ZRS`（同リージョン障害まで対応）
- `GRS` 以上は別リージョンへの複製があるため料金が上がる

## 参考文献

- [Azure Storage の冗長性](https://learn.microsoft.com/ja-jp/azure/storage/common/storage-redundancy)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
