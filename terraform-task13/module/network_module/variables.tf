variable "cidr_blockVPC" {
  type = string
  description = "Cidr block variables VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "db_subnet_cidrs" {
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zone_Subnet" {
  type = list(string)
  description = "Aviability zone Subnet"
  default = ["us-east-1a", "us-east-1b"]
}

variable "aws_zones" {
  type = list
  description = "AWS AZs (Availability zones) where subnets should be created"
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_nameTag" {
  type = string
  description = "VPC name"
  default = "My_VPC_Terraform"
}

variable "igw_nameTag" {
    type = string
  description = "VPC name"
  default = "My_IGW_Terraform"
}