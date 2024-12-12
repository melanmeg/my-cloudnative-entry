resource "google_bigquery_dataset_iam_binding" "cost_monitoring" {
  dataset_id = var.target_dataset_id
  role       = "roles/bigquery.dataViewer"
  members    = [var.sa_member]
}
