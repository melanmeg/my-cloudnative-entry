module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version                         = "33.0.4"
  project_id                      = var.project_id
  name                            = "my-gke"
  region                          = local.region
  zones                           = local.zones
  network                         = google_compute_network.default.name
  subnetwork                      = google_compute_subnetwork.default.name
  ip_range_pods                   = local.subnet.secondary_pod_ip_range.range_name
  ip_range_services               = local.subnet.secondary_service_ip_range.range_name
  stack_type                      = "IPV4"
  enable_l4_ilb_subsetting        = true # L4 内部ロードバランサー (ILB)を有効化。明示しないとterraform実行ごとに再作成要求されるため注意
  enable_vertical_pod_autoscaling = true
  horizontal_pod_autoscaling      = true
  enable_private_endpoint         = false # 外部エンドポイントアクセスを有効化
  enable_private_nodes            = true
  network_tags                    = ["allow-hoge"]
  master_ipv4_cidr_block          = "172.16.0.0/28"
  dns_cache                       = false
  deletion_protection             = false
  enable_binary_authorization     = true # Enable BinAuthZ Admission controller
  enable_cost_allocation          = true # Enables Cost Allocation Feature and the cluster name and namespace of your GKE workloads appear in the labels field of the billing export to BigQuery

  master_authorized_networks = local.master_authorized_networks

  cluster_resource_labels = local.labels
}
