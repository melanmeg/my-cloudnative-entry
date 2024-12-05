# my-cloudnative-entry

### 事前準備

- prepare/README.md 参照

### Terraform実行
```bash
$ terraform providers lock -platform=linux/amd64
```

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

- 再作成時は先に以下実行
```bash
# Workload Identity プール/プロバイダ が30日間は完全削除されないため、以下コマンドでundelete,importしておくことによりTerraformのエラーを回避。
$ gcloud iam workload-identity-pools undelete my-github-pool --location global --project test-project-373118
$ gcloud iam workload-identity-pools providers undelete my-github-pool-provider --workload-identity-pool my-github-pool --location global --project test-project-373118
# もし依存関係でエラーが起こった場合は、先にterraform applyしてから再度試す。
$ terraform import google_iam_workload_identity_pool.github_pool projects/test-project-373118/locations/global/workloadIdentityPools/my-github-pool
$ terraform import google_iam_workload_identity_pool_provider.github_pool_provider projects/test-project-373118/locations/global/workloadIdentityPools/my-github-pool/providers/my-github-pool-provider
```

### クラスタ接続
```bash
$ gcloud container clusters get-credentials my-gke --region=asia-northeast1
```

### ArgoCDデプロイ
```bash
$ ./prepare/gen_argocd_self_cert.sh
$ sops -d k8s/argocd/repo-secret.yaml | kubectl apply -f -

$ helm repo add argo https://argoproj.github.io/argo-helm
$ helm secrets install argocd argo/argo-cd --version 7.6.12 -n argocd -f k8s/argocd/argocd-helm-chart-values.yaml -f k8s/argocd/argocd-config-values.yaml
$ helm install argocd argo/argocd-apps --version 2.0.2 -f k8s/argocd/argocd-apps-helm-chart-values.yaml
```

- ドメイン取得をしていないため、Redirect URI: `https://argocd.example.com/api/dex/callback` とした
  - /etc/hostsに `[argocdのIP] argocd.example.com`を設定しておく

### クリーンアップ

```bash
$ helm uninstall argocd && \
  helm uninstall argocd -n argocd && \
  kubectl patch applications.argoproj.io wordpress -n argocd -p '{"metadata":{"finalizers":[]}}' --type=merge && \
  kubectl patch applications.argoproj.io cluster-wide-apps-external-secrets -n argocd -p '{"metadata":{"finalizers":[]}}' --type=merge && \
  kubectl patch applications.argoproj.io cluster-wide-apps-welcome-study -n argocd -p '{"metadata":{"finalizers":[]}}' --type=merge && \
  kubectl delete ns argocd

$ kubectl delete ingress --all -A
$ terraform destroy -var-file="db.tfvars" --auto-approve
```
