# Azure ストレージサービスの種類と AWS 対応表

> 種別: ユーザー議論・Q&A の記録（Phase 2 / Task 1）
> 関連教材: [02-storage-account.md](../02-storage-account.md)

## 論点

Storage Account の下にある Blob・File・Queue・Table の違いが不明だった。AWS 経験者向けに対応サービスを整理した。また RG → Storage Account → Blob の構成が正しいか確認した。

## Q&A

**Q1: Blob・File・Queue・Table の違いは？AWS だと何に該当する？**

| Azure | AWS相当 | 用途 |
|---|---|---|
| **Blob Storage** | **S3** | オブジェクトストレージ。画像・動画・ログ・バックアップ等のファイル保存 |
| **File Storage** | **EFS** | SMB/NFS でマウントできるマネージドファイルシステム。VM からネットワークドライブとして使う |
| **Queue Storage** | **SQS** | メッセージキュー。サービス間の非同期通信 |
| **Table Storage** | **DynamoDB**（簡易版） | NoSQL の KV ストア。スキーマレスなテーブル。DynamoDB より機能は少ない |

**Q2: 構成は RG → Storage Account → Blob という理解でいい？**

正しい。より詳細には：

```
Resource Group
└── Storage Account（ネームスペース）
    ├── Blob Container（バケット相当）← azurerm_storage_container
    │   ├── blob（ファイル）
    │   └── blob（ファイル）
    ├── File Share
    ├── Queue
    └── Table
```

Storage Account が「屋根」で、その下に各ストレージサービスがぶら下がる。

## 結論 / 整理

- Storage Account = AWS でいう「S3 バケットのネームスペース + EFS + SQS + DynamoDB を一まとめにした管理単位」
- Blob Storage = S3 に最も近い（オブジェクトストレージ）
- 今回の学習では Blob Storage（azurerm_storage_container）だけを使う

## 参考文献

- [Azure Blob Storage とは](https://learn.microsoft.com/ja-jp/azure/storage/blobs/storage-blobs-introduction)（閲覧日 2026-05-09）
- [Azure ストレージの概要](https://learn.microsoft.com/ja-jp/azure/storage/common/storage-introduction)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
