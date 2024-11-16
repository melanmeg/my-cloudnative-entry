# GAR 作成
resource "google_artifact_registry_repository" "my-repo" {
  location      = local.region
  repository_id = "my-repository"
  description   = "For Welcom Study"
  format        = "DOCKER"
}

# For external secrets
resource "google_project_iam_member" "external_secrets_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/external-secrets/sa/external-secrets-sa"
}

# For GKE. allow image pull
resource "google_project_iam_member" "allow_image_pull" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${module.gke.service_account}"
}

# For Cloud SQL. DNSゾーン作成
resource "google_dns_managed_zone" "default" {
  name        = "my-zone"
  description = "For me"
  dns_name    = "my-dns."
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.default.id
    }
  }

  labels = local.labels
}

# For Cloud SQL. DNSレコード作成
resource "google_dns_record_set" "default" {
  name         = "my-cloud-sql.my-dns."
  managed_zone = google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_sql_database_instance.default.private_ip_address]
}

# Ingressでの外部公開のため
resource "google_compute_security_policy" "policy" {
  name = "my-policy"

  dynamic "rule" {
    for_each = local.rules
    content {
      action   = rule.value.action
      priority = rule.value.priority
      match {
        versioned_expr = rule.value.match.versioned_expr
        config {
          src_ip_ranges = rule.value.match.config.src_ip_ranges
        }
      }
      description = rule.value.description
    }
  }
}

# argocd HTTPS
resource "google_compute_global_address" "argocd_ssl_public_ip" {
  project      = var.project_id
  name         = "argocd-ssl-public-ip"
  address_type = "EXTERNAL"
}
