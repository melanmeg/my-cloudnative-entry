terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.1.0"
    }
  }
}

provider "google" {
  project        = "my-project-melanmeg"  # "test-project-373118"
  region         = "ap-northeast-1"
  zone           = "ap-northeast-1a"
}
