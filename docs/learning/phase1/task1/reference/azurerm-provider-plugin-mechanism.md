# azurerm プロバイダーの自動実行とプラグインの実態

> 種別: ユーザー議論・Q&A の記録（Phase 1 / Task 1）
> 関連教材: [01-what-is-iac.md](../01-what-is-iac.md)

## 論点

Terraform を使っていると `azurerm` プロバイダーの存在を意識する場面がほとんどない。「これは自動で動くのか？」「実行ファイルはどこにあるのか？」という疑問が生まれた。

## Q&A

**Q1: terraform コマンドを打つと azurerm は自動で実行されるの？実行ファイルはどこにあるの？**

はい、完全に自動です。流れは以下の通り：

```
terraform init
    ↓
registry.terraform.io から azurerm のバイナリをダウンロード
    ↓
.terraform/providers/ に保存

terraform plan / apply
    ↓
Terraform コアが .terraform/providers/ のバイナリを起動
    ↓
azurerm が Azure API を叩く（ユーザーは意識しない）
```

実行ファイルの場所：

```
.terraform/
└── providers/
    └── registry.terraform.io/
        └── hashicorp/
            └── azurerm/
                └── 3.x.x/
                    └── windows_amd64/
                        └── terraform-provider-azurerm_v3.x.x.exe
```

## 結論 / 整理

- `terraform init` がプロバイダープラグインをダウンロード・配置する
- `terraform plan` / `apply` 時に Terraform コアがプラグインバイナリを自動起動する
- ユーザーは `.tf` ファイルに `required_providers` を書くだけでよい
- `.terraform/` ディレクトリはバイナリを含むため `.gitignore` に追加するのが慣習

## 参考文献

- [Terraform Plugin Architecture](https://developer.hashicorp.com/terraform/plugin/how-terraform-works)（閲覧日 2026-05-09）

---

_Saved at 2026-05-09 via /learning-flow:reference_
