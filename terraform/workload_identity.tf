# Workload Identity Pool の作成
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "my-github-pool"
  display_name              = "my-github-pool"
  description               = ""
}

# Workload Identity Pool Provider の作成
resource "google_iam_workload_identity_pool_provider" "github_provider_jwt" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "my-github-pool-provider"
  display_name                       = "my-github-pool-provider"
  description                        = ""
  attribute_mapping = {
    "google.subject"         = "assertion.sub",
    "attribute.aud"          = "assertion.aud",
    "attribute.project_path" = "assertion.project_path",
    "attribute.project_id"   = "assertion.project_id",
    "attribute.group_id"     = "assertion.project_path.startsWith('group_a/') ? 'group_a' : ''"
    "attribute.ref"          = "assertion.ref",
  }
  # Github上の特定のリポジトリからのみ利用可能なように絞っている
  attribute_condition = "assertion.repository == '${var.github_repository}'"
  oidc {
    issuer_uri        = "https://github.com"
    allowed_audiences = ["https://github.com"]
  }
}

# Github CI用サービスアカウントの作成
resource "google_service_account" "github_service_account" {
  project      = var.project_id
  account_id   = "my-github-sa"
  display_name = "github Service Account"
}

# Github CI用サービスアカウントへの Workload Identityユーザロールの付与
resource "google_service_account_iam_member" "github_runner_oidc" {
  service_account_id = google_service_account.github_service_account.id
  role               = "roles/iam.workloadIdentityUser"
  # Github上の特定のリポジトリからのみ利用可能なように絞っている
  member     = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repository}"
  depends_on = [google_service_account.github_service_account]
}

# GARへの読み込みアクセス権限を付与
resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.github_service_account.member
}

# GARへの書き込みアクセス権限を付与
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = google_service_account.github_service_account.member
}
