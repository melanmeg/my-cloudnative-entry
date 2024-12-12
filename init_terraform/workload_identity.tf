# Workload Identity Pool の作成
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = local.project_id
  workload_identity_pool_id = "my-github-pool"
  display_name              = "my-github-pool"
  description               = ""
  disabled                  = false
}

# Workload Identity Pool Provider の作成
resource "google_iam_workload_identity_pool_provider" "github_pool_provider" {
  project                            = local.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "my-github-pool-provider"
  display_name                       = "my-github-pool-provider"
  description                        = ""
  disabled                           = false
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  # Github上の特定のリポジトリからのみ利用可能なように絞っている
  attribute_condition = "assertion.repository == '${local.github_repository}'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
