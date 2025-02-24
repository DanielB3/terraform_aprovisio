resource "aws_instance" "ec2_devops_finkargo" {
  ami           = "ami-0885b1f6bd170450c"  # Nueva AMI válida
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_finkargo_1.id
  vpc_security_group_ids = [aws_security_group.sg_devops_finkargo.id]

  tags = {
    Name = "Finkargo-EC2-DevOps"
  }
}

