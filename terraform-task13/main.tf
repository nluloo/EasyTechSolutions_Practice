provider "aws" {
  region  = "us-east-1"
}

/*resource "aws_instance" "app_server" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}*/


module "vpc_module" {
  source = "./module/network_module"

  
}

module "ec2_module" {
  source = "./module/instance_module"
  public_subnet_id = module.vpc_module.public_subnet_id[0]
  private_subnet_id = module.vpc_module.private_subnet_id[0]

  security_group_private_ids = [module.vpc_module.security_group_private_ids]
  security_group_public_ids = [module.vpc_module.security_group_public_ids]

  instance_name = "ec2_Terraform"
}

module "db_module" {
  source = "./module/rds_module"

  db_password = var.db_password
  db_username = var.db_username

  db_subnets = module.vpc_module.db_subnets
  security_group_private_ids = [module.vpc_module.security_group_private_ids]
}
