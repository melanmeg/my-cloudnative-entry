resource "google_cloudfunctions_function" "cost_monitoring" {
  name                  = "${var.name}-function"
  description           = var.description
  runtime               = var.runtime
  region                = "asia-northeast1"

  max_instances         = 1
  min_instances         = 0
  available_memory_mb   = 256
  timeout               = 60
  source_archive_bucket = google_storage_bucket.cost_monitoring.name
  source_archive_object = google_storage_bucket_object.cost_monitoring.name
  entry_point           = var.entry_point

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.cost_monitoring.id
  }

  service_account_email = var.sa_email
}
