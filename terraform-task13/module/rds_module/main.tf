resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"

  subnet_ids = var.db_subnets[*].id
}

resource "aws_db_instance" "postresql-terraform" {
  engine = "postgres" 
  engine_version = "17.2"
  allocated_storage = 20
  instance_class = "db.m7g.large"
  storage_type = "gp2"
  identifier = "postresql-terraform"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = var.security_group_private_ids 

  skip_final_snapshot = true
  multi_az = true
  db_name = "postres_terraform"
  tags = {
    Name = "mydb"
  }
}
