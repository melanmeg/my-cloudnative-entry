resource "google_project_iam_member" "iam_member" {
  count   = length(var.roles)
  project = var.project_id
  role    = element(var.roles, count.index)
  member  = "${var.member_type}:${var.email}"
}
