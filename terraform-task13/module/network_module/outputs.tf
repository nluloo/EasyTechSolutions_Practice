output "vpc_id" {
  value = aws_vpc.my_vpc.id
}


output "public_subnet_id" {
  
  value = "${aws_subnet.public_subnet.*.id}"
}

output "db_subnets" {
  value = "${aws_subnet.db_subnet}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "nat_gateway_id" {
  value = "${aws_nat_gateway.my_nat_gateway.*.id}"
}

output "security_group_private_ids" {
  value = aws_security_group.private_sg.id
}

output "security_group_public_ids" {
  value = aws_security_group.public_sg.id
}