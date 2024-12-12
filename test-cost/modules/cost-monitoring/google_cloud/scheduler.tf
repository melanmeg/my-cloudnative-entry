resource "google_cloud_scheduler_job" "cost_monitoring" {
  name        = "${var.name}-scheduler-job"
  description = var.description
  schedule    = var.schedule
  region      = "asia-northeast1"

  pubsub_target {
    topic_name = google_pubsub_topic.cost_monitoring.id
    data       = base64encode("{}")  # dataは必須だが、値は何でも良い
  }

  retry_config {
    max_backoff_duration = "3600s"
    max_doublings        = 5
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
    retry_count          = 0
  }
}
