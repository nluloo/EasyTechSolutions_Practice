variable "db_subnets" {
  default = ""
}

variable "security_group_private_ids" {
}


variable "db_password" {
  sensitive = true
}

variable "db_username" {
  sensitive = true
}