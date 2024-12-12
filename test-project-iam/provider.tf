terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.1.0"
    }
  }
}

provider "google" {
  project        = "test-project-373118" # "my-project-melanmeg"
  region         = "ap-northeast-1"
  zone           = "ap-northeast-1a"
}
