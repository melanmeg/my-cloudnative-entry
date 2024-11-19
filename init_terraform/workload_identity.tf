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

# Githubのリポジトリに対する権限を付与
resource "google_artifact_registry_repository_iam_member" "artifact_registry_writer" {
  project    = local.project_id
  repository = google_artifact_registry_repository.my-repo.name
  location   = google_artifact_registry_repository.my-repo.location
  role       = "roles/artifactregistry.writer"
  member     = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.github_repository}"
}

resource "google_storage_bucket_iam_member" "bucket_iam_member" {
  for_each = toset([
    "roles/storage.objectAdmin"  # GCSバケットに対する権限を付与
  ])
  bucket = local.bucket_name
  role   = each.key
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.github_repository}"
}

resource "google_project_iam_member" "project_iam_member" {
  for_each = toset([
    "roles/container.viewer",  # GKEクラスターに対するIAM権限を付与
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",  # Cloud KMSに対する権限を付与
  ])
  project  = local.project_id
  role     = each.key
  member   = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.github_repository}"
}
