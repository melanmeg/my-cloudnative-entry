terraform {
  backend "gcs" {
    bucket  = "test-project-373118-tfstate-bucket"
    prefix  = "test-project-373118/state"
  }
}

module "all" {
  source = "../modules"

  project_id        = "test-project-373118"
  project_number    = "593997455442"
  owner             = "melanmeg"
  bucket_name       = "test-project-373118-tfstate-bucket"
  db_user           = "db-user"
}
