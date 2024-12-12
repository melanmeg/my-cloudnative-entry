
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_service_account" "account" {
  project      = var.project_id
  account_id   = var.service_account_info.account_id
  display_name = var.service_account_info.display_name
  description  = var.service_account_info.description
}

data "google_iam_policy" "account_iam_policy" {
  dynamic "binding" {
    for_each = var.service_account_iam
    content {
      role    = binding.value.role
      members = binding.value.members
    }
  }
}

resource "google_service_account_iam_policy" "account_iam_policy" {
  service_account_id = google_service_account.account.name
  policy_data        = data.google_iam_policy.account_iam_policy.policy_data
}

module "iam_member" {
  source      = "../iam_member"
  project_id  = data.google_project.project.id
  email       = google_service_account.account.email
  roles       = var.roles
  member_type = "serviceAccount"
}
