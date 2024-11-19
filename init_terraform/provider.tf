terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.1.0"
    }
  }
  backend "gcs" {
    bucket  = "test-project-373118-tfstate-bucket"
    prefix  = "test-project-373118/init-state"
  }
}

provider "google" {
  project        = local.project_id
  region         = local.region
  zone           = local.zones[0]
  default_labels = local.labels
}
