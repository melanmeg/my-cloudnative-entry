variable "project_id" {
  type = string
}

variable "member_type" {
  type = string

  validation {
    condition     = contains(["serviceAccount", "user", "group", "domain"], var.member_type)
    error_message = "The member_type must be one of serviceAccount, user, group and domain."
  }
}

variable "email" {
  type = string
}

variable "roles" {
  type = list(string)

  # 配列内部が全てroles/から始まることを検証する
  #  validation {
  #    condition = length([
  #      for role in var.champs-nextjs-cloud-run_roles : true
  #      if can(regex("^roles/.*$", role))
  #    ]) == length(var.champs-nextjs-cloud-run_roles)
  #    error_message = "All rules must start with \"role/\"."
  #  }
}
