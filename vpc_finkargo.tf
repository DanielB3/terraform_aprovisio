# Crear VPC
resource "aws_vpc" "vpc_finkargo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Finkargo-VPC"
  }
}

# Crear Internet Gateway para la VPC
resource "aws_internet_gateway" "igw_finkargo" {
  vpc_id = aws_vpc.vpc_finkargo.id

  tags = {
    Name = "Finkargo-Internet-Gateway"
  }
}

# Crear la primera subred pública en us-east-1a
resource "aws_subnet" "public_subnet_finkargo_1" {
  vpc_id                  = aws_vpc.vpc_finkargo.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Finkargo-Public-Subnet-1"
  }
}

# Crear la segunda subred pública en us-east-1b
resource "aws_subnet" "public_subnet_finkargo_2" {
  vpc_id                  = aws_vpc.vpc_finkargo.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Finkargo-Public-Subnet-2"
  }
}

# Crear la primera subred privada en us-east-1a
resource "aws_subnet" "private_subnet_finkargo_1" {
  vpc_id            = aws_vpc.vpc_finkargo.id
  cidr_block        = "10.0.103.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Finkargo-Private-Subnet-1"
  }
}

# Crear la segunda subred privada en us-east-1b
resource "aws_subnet" "private_subnet_finkargo_2" {
  vpc_id            = aws_vpc.vpc_finkargo.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Finkargo-Private-Subnet-2"
  }
}

# Crear la tabla de enrutamiento pública
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

# Crear la tabla de enrutamiento privada
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

# Asociar la primera subred pública con la tabla de enrutamiento pública
resource "aws_route_table_association" "public_assoc_finkargo_1" {
  subnet_id      = aws_subnet.public_subnet_finkargo_1.id
  route_table_id = aws_route_table.public_rt_finkargo.id
}

# Asociar la segunda subred pública con la tabla de enrutamiento pública
resource "aws_route_table_association" "public_assoc_finkargo_2" {
  subnet_id      = aws_subnet.public_subnet_finkargo_2.id
  route_table_id = aws_route_table.public_rt_finkargo.id
}

# Asociar la primera subred privada con la tabla de enrutamiento privada
resource "aws_route_table_association" "private_assoc_finkargo_1" {
  subnet_id      = aws_subnet.private_subnet_finkargo_1.id
  route_table_id = aws_route_table.private_rt_finkargo.id
}

# Asociar la segunda subred privada con la tabla de enrutamiento privada
resource "aws_route_table_association" "private_assoc_finkargo_2" {
  subnet_id      = aws_subnet.private_subnet_finkargo_2.id
  route_table_id = aws_route_table.private_rt_finkargo.id
}

# Asignar Elastic IP para el NAT Gateway
resource "aws_eip" "nat_eip_finkargo" {
  domain = "vpc"

  tags = {
    Name = "Finkargo-NAT-EIP"
  }
}

# Crear el NAT Gateway en la primera subred pública
resource "aws_nat_gateway" "nat_finkargo" {
  allocation_id = aws_eip.nat_eip_finkargo.id
  subnet_id     = aws_subnet.public_subnet_finkargo_1.id

  tags = {
    Name = "Finkargo-NAT-Gateway"
  }
}

