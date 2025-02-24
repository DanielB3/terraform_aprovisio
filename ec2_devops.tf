resource "aws_instance" "ec2_devops_finkargo" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet_finkargo.id
  security_groups = [aws_security_group.sg_devops_finkargo.name]

  tags = {
    Name = "Finkargo-EC2-DevOps"
  }
}
