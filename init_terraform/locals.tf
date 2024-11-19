locals {
  project_id        = "test-project-373118"
  project_number    = "593997455442"
  owner             = "melanmeg"
  bucket_name       = "test-project-373118-tfstate-bucket"
  github_repository = "melanmeg/my-cloudnative-entry"
  region            = "asia-northeast1"
  zones             = ["asia-northeast1-a"]
  labels = {
    "environment" : "dev",
    "project_id" : "test-project-373118",
    "owner" : "melanmeg"
  }
}
