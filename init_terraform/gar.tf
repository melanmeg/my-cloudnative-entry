# GAR 作成
resource "google_artifact_registry_repository" "my-repo" {
  location         = local.region
  repository_id    = "my-repository"
  description      = "For Welcom Study"
  format           = "DOCKER"
}
