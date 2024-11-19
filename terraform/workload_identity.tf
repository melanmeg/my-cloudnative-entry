# Workload Identity Pool の作成
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "my-github-pool"
  display_name              = "my-github-pool"
  description               = ""
  disabled                  = false
}

# Workload Identity Pool Provider の作成
resource "google_iam_workload_identity_pool_provider" "github_pool_provider" {
  project                            = var.project_id
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
  attribute_condition = "assertion.repository == '${var.github_repository}'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# GAR 作成
resource "google_artifact_registry_repository" "my-repo" {
  location      = local.region
  repository_id = "my-repository"
  description   = "For Welcom Study"
  format        = "DOCKER"
}

# Githubのリポジトリに対する権限を付与
resource "google_artifact_registry_repository_iam_member" "artifact_registry_writer" {
  project    = var.project_id
  repository = google_artifact_registry_repository.my-repo.name
  location   = google_artifact_registry_repository.my-repo.location
  role       = "roles/artifactregistry.writer"
  member     = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repository}"
}

# GCSバケットに対する権限を付与
resource "google_storage_bucket_iam_member" "storage_object_admin" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repository}"
}
