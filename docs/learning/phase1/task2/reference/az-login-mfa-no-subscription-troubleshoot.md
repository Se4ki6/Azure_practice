# az login の MFA エラー・サブスクリプション未検出の対処

> 種別: ユーザー議論・Q&A の記録（Phase 1 / Task 2）
> 関連教材: [01-azure-auth.md](../01-azure-auth.md)

## 論点

`az login` を実行すると MFA エラーと「No subscriptions found」が出て認証できなかった。Portal は開けているのに CLI だけ失敗する状況。

## Q&A

**Q1: az login を実行したら MFA エラーが出た**

エラー内容:
```
AADSTS50076: Due to a configuration change made by your administrator...
you must use multi-factor authentication
```

**原因**: CLI のデフォルトの認証フローではテナントの MFA 要件を満たせないケースがある。

**対処**: `--tenant` を明示することでブラウザ経由の MFA フローが正しく起動する：

```powershell
az login --tenant d92d8acd-a3c2-4792-8c72-a8b1f153297c
```

**Q2: MFA は通ったが「No subscriptions found」と出た**

**原因**: アカウントにサブスクリプションが紐付いていなかった。

**対処**: Azure Portal の「サブスクリプション」ページから作成。
- 新規の場合 → 無料試用版（$200 クレジット）
- すでに Azure アカウントがある場合 → 「Use an existing subscription」または「Pay-As-You-Go」を選択

**Q3: 「Looks like you already have an Azure account」と表示された**

無料試用版は 1 アカウント 1 回のみ。この場合は「Use an existing subscription in your account」をクリックして既存サブスクリプションを確認する。または「Pay-As-You-Go」で新規作成。

## 結論 / 整理

- MFA エラー → `az login --tenant <TENANT_ID>` で解決
- サブスクリプション未検出 → Portal でサブスクリプションを作成してから再ログイン
- 成功確認コマンド: `az account list --output table`

## 参考文献

- [Azure CLI でのサインイン](https://learn.microsoft.com/ja-jp/cli/azure/authenticate-azure-cli)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
