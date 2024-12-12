# # サービスアカウントの作成
# resource "google_service_account" "bigquery_sa" {
#   account_id   = "github-actions-sa"
#   display_name = "BigQuery Access Service Account"
# }

# # サービスアカウントにBigQueryのアクセス権を付与
# resource "google_project_iam_binding" "bigquery_sa_binding" {
#   project = "my-project-melanmeg"
#   role    = "roles/bigquery.dataViewer"
#   members = [
#     "serviceAccount:${google_service_account.bigquery_sa.email}",
#   ]
# }

# # サービスアカウントへの権限を付与
# resource "google_service_account_iam_member" "bigquery_sa_permission" {
#   service_account_id = google_service_account.bigquery_sa.id
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "principalSet://iam.googleapis.com/projects/593997455442/locations/global/workloadIdentityPools/my-github-pool/attribute.repository/melanmeg/my-cloudnative-entry"
# }
