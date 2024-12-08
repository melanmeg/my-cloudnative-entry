resource "google_storage_bucket" "example_bucket" {
  name          = "test-project-373118-sample-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

# resource "google_storage_bucket" "example_bucket2" {
#   name          = "test-project-373118-sample-bucket2"
#   location      = "US"
#   force_destroy = true

#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }
#     condition {
#       age = 30
#     }
#   }
# }
