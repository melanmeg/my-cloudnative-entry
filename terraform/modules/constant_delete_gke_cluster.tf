resource "google_pubsub_topic" "default" {
  name   = "my-gke-scheduler-topic"
  labels = local.labels
}

resource "google_storage_bucket" "default" {
  name     = "my-gke-function-bucket"
  location = "ASIA"
  labels   = local.labels
}

resource "google_storage_bucket_object" "default" {
  name   = "function_source.zip"
  bucket = google_storage_bucket.default.name
  source = "${path.module}/function/function_source.zip"
}

resource "google_cloudfunctions_function" "default" {
  name                  = "my-gke-control-function"
  runtime               = "python310"
  entry_point           = "gke_control"
  source_archive_bucket = google_storage_bucket.default.name
  source_archive_object = google_storage_bucket_object.default.name
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.default.id
  }

  environment_variables = {
    CLUSTER_ID = module.gke.cluster_id
  }

  labels = local.labels
}

resource "google_cloud_scheduler_job" "default" {
  name        = "my-gke-delete-job"
  description = "Delete GKE Cluster at night"
  schedule    = local.schedule # 定期日時に削除
  pubsub_target {
    topic_name = google_pubsub_topic.default.id
    data = base64encode(jsonencode({ # 必ずdata設定が必要。
      action = "delete"              # データをBase64形式にエンコードする。
    }))
  }
}
