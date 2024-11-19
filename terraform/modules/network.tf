# network
resource "google_compute_network" "default" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

# subnet
resource "google_compute_subnetwork" "default" {
  name          = local.subnet.name
  ip_cidr_range = local.subnet.ip_cidr_range
  region        = local.region
  stack_type    = local.subnet.stack_type
  network       = google_compute_network.default.id

  secondary_ip_range {
    range_name    = local.subnet.secondary_service_ip_range.range_name
    ip_cidr_range = local.subnet.secondary_service_ip_range.ip_cidr_range
  }

  secondary_ip_range {
    range_name    = local.subnet.secondary_pod_ip_range.range_name
    ip_cidr_range = local.subnet.secondary_pod_ip_range.ip_cidr_range
  }
}

# nat
resource "google_compute_router" "default" {
  name    = "my-nat-router"
  project = var.project_id
  region  = local.region
  network = google_compute_network.default.self_link
}

resource "google_compute_address" "default" {
  name    = "my-nat-address"
  project = var.project_id
  region  = local.region
}

resource "google_compute_router_nat" "default" {
  name                   = "my-nat"
  project                = var.project_id
  region                 = local.region
  router                 = google_compute_router.default.name
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
