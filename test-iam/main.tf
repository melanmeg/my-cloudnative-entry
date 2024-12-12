# resource "google_project_iam_member" "bigquery_access" {
#   project = "my-project-melanmeg"
#   role    = "roles/bigquery.dataViewer"
#   member  = "serviceAccount:cost-monitoring-sa@test-project-373118.iam.gserviceaccount.com"
# }

# サービスアカウントの作成
resource "google_service_account" "bigquery_sa" {
  account_id   = "github-actions-sa"
  display_name = "BigQuery Access Service Account"
}

# サービスアカウントにBigQueryのアクセス権を付与
resource "google_project_iam_binding" "bigquery_sa_binding" {
  project = "my-project-melanmeg"
  role    = "roles/bigquery.dataViewer"
  members = [
    "serviceAccount:${google_service_account.bigquery_sa.email}",
  ]
}

# サービスアカウントへの権限を付与
resource "google_service_account_iam_member" "bigquery_sa_permission" {
  service_account_id = google_service_account.bigquery_sa.id
  role               = "roles/iam.serviceAccountUser" # 必要なIAMロールを指定
  member             = "serviceAccount:cost-monitoring-sa@test-project-373118.iam.gserviceaccount.com"
}
