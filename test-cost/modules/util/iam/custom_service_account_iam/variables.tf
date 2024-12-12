variable "project_id" {
  type        = string
  description = "Project ID for management"
}

variable "service_account_info" {
  type = object({
    account_id   = string,
    display_name = string,
    description  = string,
  })
}

variable "service_account_iam" {
  type = set(object({
    role    = string,
    members = list(string),
  }))
  default   = []
}

variable "roles" {
  type = list(string)
}
