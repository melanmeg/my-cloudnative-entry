# Workload Identity Pool の作成
resource "google_iam_workload_identity_pool" "gitlab_pool" {
  workload_identity_pool_id = "my-gitlab-pool"
  project                   = var.project_id
}

# Workload Identity Pool Provider の作成
resource "google_iam_workload_identity_pool_provider" "gitlab_provider_jwt" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.gitlab_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "my-gitlab-pool-provider"
  project                            = var.project_id
  attribute_mapping = {
    "google.subject"         = "assertion.sub",
    "attribute.aud"          = "assertion.aud",
    "attribute.project_path" = "assertion.project_path",
    "attribute.project_id"   = "assertion.project_id",
    "attribute.group_id"     = "assertion.project_path.startsWith('group_a/') ? 'group_a' : ''"
    "attribute.ref"          = "assertion.ref",
  }
  # GitLab上の特定のプロジェクトからのみ利用可能なように絞っている
  attribute_condition = "assertion.project_id == '${local.gitlab_project_id}'"
  oidc {
    issuer_uri        = local.gitlab_url
    allowed_audiences = [local.gitlab_url]
  }
}

# Gitlab CI用サービスアカウントの作成
resource "google_service_account" "gitlab_service_account" {
  account_id   = "my-gitlab-sa"
  display_name = "GitLab Service Account"
  project      = var.project_id
}

# Gitlab CI用サービスアカウントへの Workload Identityユーザロールの付与
resource "google_service_account_iam_member" "gitlab_runner_oidc" {
  service_account_id = google_service_account.gitlab_service_account.id
  role               = "roles/iam.workloadIdentityUser"
  # GitLab上の特定のプロジェクトからのみ利用可能なように絞っている
  member     = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab_pool.name}/attribute.project_id/${local.gitlab_project_id}"
  depends_on = [google_service_account.gitlab_service_account]
}

# GARへの読み込みアクセス権限を付与
resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.gitlab_service_account.member
}

# GARへの書き込みアクセス権限を付与
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = google_service_account.gitlab_service_account.member
}
