variable "project_id" {
  type        = string
  sensitive   = false
}
variable "project_number" {
  type        = string
  sensitive   = false
}
variable "owner" {
  type        = string
  sensitive   = false
}
variable "authorized_networks" {
  type        = list(string)
  sensitive   = true
}
variable "github_repository" {
  type        = string
  sensitive   = false
}
variable "bucket_name" {
  description = ""
  type        = string
  sensitive   = false
}
variable "db_user" {
  description = ""
  type        = string
  sensitive   = false
}
variable "db_password" {
  description = ""
  type        = string
  sensitive   = true
}
