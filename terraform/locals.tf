locals {
  # common
  region         = "asia-northeast1"
  zones          = ["asia-northeast1-a"]
  labels = {
    "environment" : "dev",
    "project_id" : var.project_id,
    "owner" : var.owner
  }

  # authorized networks
  master_authorized_networks = [
    {
      cidr_block   = var.authorized_networks[0] # 承認済みネットワークのアドレス範囲設定
      display_name = "VPC"
    },
    {
      cidr_block   = var.authorized_networks[1] # 承認済みネットワークのアドレス範囲設定
      display_name = "VPC"
    }
  ]

  # subnet
  subnet = {
    name          = "my-subnet"
    ip_cidr_range = "192.168.0.0/24"
    stack_type    = "IPV4_ONLY"
    secondary_pod_ip_range = {
      range_name    = "pod-ranges"
      ip_cidr_range = "10.128.0.0/16"
    }
    secondary_service_ip_range = {
      range_name    = "services-range"
      ip_cidr_range = "10.96.0.0/16"
    }
  }

  # Cloud Armor Policy
  rules = [
    # デフォルトルール
    {
      action   = "deny(403)"  # すべてのアクセスをデフォルトで拒否する
      priority = "2147483647"  # 必須の優先度
      match = {
        versioned_expr = "SRC_IPS_V1"
        config = {
          src_ip_ranges = ["*"]
        }
      }
      description = "Deny access to All IPs"
    },
    {
      action   = "allow"
      priority = "1000"
      match = {
        versioned_expr = "SRC_IPS_V1"
        config = {
          src_ip_ranges = [var.authorized_networks[0]]
        }
      }
      description = "Allow access to VPC"
    }
  ]

  # GKEクラスタ定期削除
  schedule = "0 22 * * *" # 毎日22時に削除

  # gitlab
  gitlab_project_id = var.gitlab_project_id # GitLabのプロジェクトID
  gitlab_url        = "https://gitlab.com"
}
