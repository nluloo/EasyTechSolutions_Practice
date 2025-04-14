output "PublicIP" {
  value = aws_instance.bastion_host.public_ip
}

output "PrivateIP_privateInstance" {
  value = aws_instance.bastion_host.private_ip
}

