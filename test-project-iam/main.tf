module "cost-monitoring" {
  source = "./modules/cost-monitoring/google_cloud"

  project_id  = "test-project-373118"
  name        = "cost-monitoring"
  description = "For cost monitoring"

  schedule          = "0 8 * * 1-5"  # 平日朝8時に実行
  runtime           = "nodejs20"
  entry_point       = "send_slack_notify"
  target_dataset_id = "test_billing_dataset"

  sa_email  = module.cost-monitoring-sa.service_account.email
  sa_member = module.cost-monitoring-sa.service_account.member
}

module "cost-monitoring-sa" {
  source = "./modules/util/iam/custom_service_account_iam"

  project_id = "test-project-373118"
  service_account_info = {
    account_id   = "cost-monitoring-sa",
    display_name = "cost-monitoring-sa",
    description  = "",
  }
  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/bigquery.jobUser"
  ]
}
