variable "instance_name" {
  type = string
  description = "Instance name"
  default = ""
}

variable "instance_ami" {
  type = string
  description = "AMI instance"
  default = "ami-084568db4383264d4"
}

variable "public_subnet_id" {
  type = string
  description = "Value public subnet"
  default = ""
}

variable "Key_pab" {
  type = string
  default = "Task2-key-Virginia"
}

variable "security_group_public_ids" {
  type = set(string)
  default = [""]
}

variable "security_group_private_ids" {
  type = set(string)
  default = [ "" ]
}

variable "private_subnet_id" {
  type = string
  default = ""
}