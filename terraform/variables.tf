variable "project_id" {
  description = "The Project ID"
  type        = string
  sensitive   = false
}

variable "project_number" {
  description = "The Project Number"
  type        = string
  sensitive   = false
}

variable "owner" {
  description = "The Owner"
  type        = string
  sensitive   = false
}

variable "authorized_networks" {
  description = "The Authorized Networks"
  type        = list(string)
  sensitive   = true
}

variable "gitlab_project_id" {
  description = "The GitLab Project ID"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The user for the SQL user"
  type        = string
  sensitive   = false
}

variable "db_password" {
  description = "The password for the SQL user"
  type        = string
  sensitive   = true
}
