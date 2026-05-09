# チーム開発における .tfstate の整合性問題と Remote Backend

> 種別: ユーザー議論・Q&A の記録（Phase 1 / Task 1）
> 関連教材: [01-what-is-iac.md](../01-what-is-iac.md)

## 論点

`.tf` ファイルは Git で共有できるが、`terraform.tfstate` がローカルにある場合、他の開発者のローカルには存在しない。チームで開発する際に差分の一致をどう保証するのかという疑問が生まれた。

## Q&A

**Q1: Git に乗せても .tfstate が他の開発者のローカルにないことがある。差分の一致をどうしているのか？**

ローカル .tfstate のままではチーム開発は破綻します。問題を整理すると：

```
開発者 A の .tfstate  ←── A が apply した状態
開発者 B の .tfstate  ←── B が apply した状態（A と違う！）

→ 誰の .tfstate が「正」か分からない
→ 同時に apply したら二重作成・競合が起きる
```

**解決策: Remote Backend（リモートバックエンド）**

`.tfstate` を全員が参照できる共有ストレージに置く：

```
開発者 A ─┐
           ├─→ Azure Blob Storage の .tfstate ←── 唯一の正
開発者 B ─┘
```

さらに **State Lock（ロック）** により同時 apply を防ぐ：

```
A が terraform apply 中
    ↓
.tfstate にロックがかかる
    ↓
B が同時に apply しようとすると "Error: state locked" でブロック
```

## 結論 / 整理

- ローカル .tfstate は個人開発のみ有効。チーム開発では使ってはいけない
- Remote Backend で .tfstate を共有ストレージ（Azure Blob 等）に置くのが正解
- State Lock により同時 apply による競合を防止できる
- `.tfstate` を Git に直接コミットする運用は**アンチパターン**（機密情報が含まれることがある + 競合が起きる）

## 比較表

| | ローカル .tfstate | Remote Backend |
|---|---|---|
| 複数人での利用 | 破綻する | 可能 |
| 同時 apply の防止 | できない | State Lock で防止 |
| 機密情報の管理 | Git に混入リスク | Blob のアクセス制御で保護 |
| CI/CD での利用 | 困難 | 標準的な構成 |

## 参考文献

- [Backend Configuration - Terraform Docs](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)（閲覧日 2026-05-09）
- [azurerm Backend](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
