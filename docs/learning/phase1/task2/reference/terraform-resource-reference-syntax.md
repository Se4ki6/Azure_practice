# Terraform リソース参照構文（type.name.attr）の詳細

> 種別: ユーザー議論・Q&A の記録（Phase 1 / Task 2）
> 関連教材: [02-provider-config.md](../02-provider-config.md)

## 論点

`azurerm_resource_group.rg.name` という参照構文が何を意味するのか、3つのパーツがそれぞれどこから来るのかを詳しく知りたかった。

## Q&A

**Q1: `azurerm_resource_group.rg.name` について詳しく教えて**

3 つのパーツで構成されている：

```
azurerm_resource_group  .  rg  .  name
        ①                  ②       ③
```

| パーツ | 意味 | どこから来るか |
|---|---|---|
| ① `azurerm_resource_group` | リソースタイプ | `resource` ブロックの 1 番目の文字列 |
| ② `rg` | ローカル名 | `resource` ブロックの 2 番目の文字列 |
| ③ `name` | 属性名 | そのリソースが持つ値 |

コードとの対応：

```hcl
resource "azurerm_resource_group" "rg" {  # ① と ② はここで定義
  name     = "myResourceGroup"            # ③ .name はこの値が返る
  location = "Japan East"
}

resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.rg.name
  # → "myResourceGroup" という文字列が入る
}
```

## 結論 / 整理

- ハードコードより参照を使うと、名前変更時に 1 箇所直すだけで連動する
- 参照を書くことで Terraform が暗黙的な依存関係を把握し、作成順序を自動調整する
- 属性には「入力（自分で書く値）」と「出力（apply 後に Azure が払い出す値）」の 2 種類がある

## 比較表

| | ハードコード | 参照 |
|---|---|---|
| 名前変更時 | 複数箇所を直す | 1 箇所だけ |
| 依存関係の自動検出 | されない | される |
| 推奨 | ❌ | ✅ |

## 属性の種類

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"  # 入力属性（自分で書く）
  location = "Japan East"       # 入力属性（自分で書く）
  # id = ...                    # 出力属性（apply 後に Azure が払い出す）
}
```

使える属性の一覧は Terraform Registry の各リソースページ「Attributes Reference」セクションで確認できる。

## 参考文献

- [azurerm_resource_group – Attributes Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#attributes-reference)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
