resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_blockVPC

  tags = {
    Name = var.vpc_nameTag
  }
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  

  tags = {
    Name = var.igw_nameTag
  }
}

resource "aws_subnet" "public_subnet" {
  count = "${length(var.aws_zones)}"
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_zones[count.index]}"

  tags = {
    Name = "public_subnet-${var.aws_zones[count.index]}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = "${length(var.aws_zones)}"
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = "${var.aws_zones[count.index]}"

  tags = {
    Name = "private_subnet-${var.aws_zones[count.index]}"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.aws_zones)
  domain = "vpc"

  tags = {
    Name = "nat_eip-${var.aws_zones[count.index]}"
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count  = length(var.aws_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "nat_gw-${var.aws_zones[count.index]}"
  }

  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.aws_zones)
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway[count.index].id
  }

  tags = {
    Name = "private_rt-${var.aws_zones[count.index]}"
  }
}

resource "aws_route_table" "public_route_table" {
  count = length(var.aws_zones)
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_rt-${var.aws_zones[count.index]}"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.aws_zones)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.aws_zones)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_subnet" "db_subnet" {
  count = length(var.db_subnet_cidrs)
  availability_zone = "${var.aws_zones[count.index]}"
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.db_subnet_cidrs[count.index]
  tags = {
    Name = "db_subnet-${var.aws_zones[count.index]}"
  }
}


resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags={
    Name = "private_sg"
  }

    ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags={
    Name = "public_sg"
  }

    ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}



