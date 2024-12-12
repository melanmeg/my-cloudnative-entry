resource "google_project_iam_member" "bigquery_access" {
  project = "my-project-melanmeg"
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:cost-monitoring-sa@test-project-373118.iam.gserviceaccount.com"
}
