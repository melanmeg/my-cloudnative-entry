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

# resource "google_project_iam_member" "project_iam_member_test" {
#   for_each = toset([
#     "roles/resourcemanager.projectIamAdmin",  # プロジェクトのIAM権限を付与
#   ])
#   project  = "my-project-melanmeg"
#   role     = each.key
#   member   = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${local.github_repository}"
# }
