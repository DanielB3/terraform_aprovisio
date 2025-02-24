resource "aws_vpc" "vpc_finkargo" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Finkargo-VPC"
  }
}

resource "aws_subnet" "public_subnet_finkargo" {
  vpc_id                  = aws_vpc.vpc_finkargo.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Finkargo-Public-Subnet"
  }
}

resource "aws_subnet" "private_subnet_finkargo" {
  vpc_id            = aws_vpc.vpc_finkargo.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "Finkargo-Private-Subnet"
  }
}

resource "aws_internet_gateway" "igw_finkargo" {
  vpc_id = aws_vpc.vpc_finkargo.id

  tags = {
    Name = "Finkargo-Internet-Gateway"
  }
}

resource "aws_route_table" "public_rt_finkargo" {
  vpc_id = aws_vpc.vpc_finkargo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_finkargo.id
  }

  tags = {
    Name = "Finkargo-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_assoc_finkargo" {
  subnet_id      = aws_subnet.public_subnet_finkargo.id
  route_table_id = aws_route_table.public_rt_finkargo.id
}

resource "aws_eip" "nat_eip_finkargo" {
  vpc = true
}

resource "aws_nat_gateway" "nat_finkargo" {
  allocation_id = aws_eip.nat_eip_finkargo.id
  subnet_id     = aws_subnet.public_subnet_finkargo.id

  tags = {
    Name = "Finkargo-NAT-Gateway"
  }
}

resource "aws_route_table" "private_rt_finkargo" {
  vpc_id = aws_vpc.vpc_finkargo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_finkargo.id
  }

  tags = {
    Name = "Finkargo-Private-Route-Table"
  }
}

resource "aws_route_table_association" "private_assoc_finkargo" {
  subnet_id      = aws_subnet.private_subnet_finkargo.id
  route_table_id = aws_route_table.private_rt_finkargo.id
}
