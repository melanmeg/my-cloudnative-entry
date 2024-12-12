data "archive_file" "cost_monitoring" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src/src.zip"
  excludes    = [
    "node_modules",
    ".gitignore",
    ".tool-versions",
  ]
}

resource "google_storage_bucket" "cost_monitoring" {
  name                        = "${var.project_id}-${var.name}-bucket"
  location                    = "asia-northeast1"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "cost_monitoring" {
  name   = "${var.name}_${data.archive_file.cost_monitoring.output_md5}"
  bucket = google_storage_bucket.cost_monitoring.name
  source = data.archive_file.cost_monitoring.output_path
}
