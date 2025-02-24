output "vpc_id" {
  value = aws_vpc.vpc_finkargo.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_finkargo.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet_finkargo.id
}

output "instance_public_ip" {
  value = aws_instance.ec2_devops_finkargo.public_ip
}
