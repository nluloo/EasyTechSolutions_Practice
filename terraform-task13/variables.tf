variable "instance_name" {
  type = string
  description = "Instance name"
  default = "ExampleAppServerInstanceVariable"
}


variable "db_password" {
  sensitive = true
}

variable "db_username" {
  sensitive = true
}