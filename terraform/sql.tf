resource "google_compute_global_address" "cloud-sql" {
  name          = "my-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloud-sql.name]
  deletion_policy         = "ABANDON" # CloudSQL インスタンスを破棄するときに terraform destroy が正常に実行されるようにする
}

resource "google_sql_database_instance" "default" {
  name                = "my-sql-instance"
  database_version    = "MYSQL_8_0"
  region              = local.region
  deletion_protection = false

  depends_on = [google_service_networking_connection.default]

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      enabled = false # 自動バックアップ無効化
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.default.self_link
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database" "default" {
  name     = "wordpress-database"
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "default" {
  name            = var.db_user
  instance        = google_sql_database_instance.default.name
  password        = var.db_password
  host            = "%"
  deletion_policy = "ABANDON" # SQL ロールが付与されているユーザーを API から削除できない Postgres で役立つ
}
