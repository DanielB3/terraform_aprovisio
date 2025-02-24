variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR de la subred pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR de la subred privada"
  type        = string
  default     = "10.0.3.0/24"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 para DevOps"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI de la instancia EC2 (Amazon Linux 2 en us-east-1)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}
