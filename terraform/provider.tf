terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.1.0"
    }
  }
  backend "gcs" {
    bucket  = "test-project-373118-tfstate-bucket"
    prefix  = "test-project-373118/state"
  }
}

provider "google" {
  project        = var.project_id
  region         = local.region
  zone           = local.zones[0]
  default_labels = local.labels
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
