### 事前準備

- `terraform/env/secret.enc.json`を用意

```json
{
  "authorized_networks": ["x.x.x.x/32"],
  "db": {
    "password": "DB_PASSWORD"
  }
}
```

```bash
$ sops -e -i ../terraform/env/secret.enc.json
```

- `terraform/provider.tf`にbackendを設定する
```tf
terraform {
  backend "gcs" {
    bucket  = "test-project-373118-tfstate-bucket"
    prefix  = "test-project-373118/state"
  }
}
```

- 事前準備シェル

```bash
# Variablesは適宜編集
$ ./prepare.sh
```

- デプロイキー設定
  - 対象リポジトリに対して設定して`repo-secret.yaml`に秘密鍵を設定する

- Githubに`OAuth Apss`を追加して、`ClientID`,`CliendSecret`を`argocd-dex-config-values.yaml`に設定する
  - `Authorization callback URL`は`https://argocd.example.com`
  - `Homepage URL`は`https://argocd.example.com/api/dex/callback`とする

- k8s/argocd/repo-secret.yamlの内容

```bash
# ref: https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repositories-yaml/
apiVersion: v1
kind: Secret
metadata:
    name: private-ssh-repo
    namespace: argocd
    labels:
        argocd.argoproj.io/secret-type: repository
stringData:
    url: git@github.com:melanmeg/my-cloudnative-entry.git
    sshPrivateKey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        ...
        -----END OPENSSH PRIVATE KEY-----
    insecure: "true"
    enableLfs: "true"
```

- ファイル暗号化
```bash
$ sops -e -i ../k8s/argocd/repo-secret.yaml
$ sops -e -i ../k8s/argocd/argocd-config-values.yaml
```
