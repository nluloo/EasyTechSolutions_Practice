resource "aws_instance" "bastion_host" {
  ami = var.instance_ami
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id

  key_name = var.Key_pab

  vpc_security_group_ids = var.security_group_public_ids

  tags = {
    Name = "Bastion_host"
  }
}


resource "aws_instance" "private_host" {
  ami = var.instance_ami
  instance_type = "t2.micro"
  subnet_id = var.private_subnet_id

  key_name = var.Key_pab

  vpc_security_group_ids = var.security_group_private_ids

  tags = {
    Name = "private_host"
  }
}


