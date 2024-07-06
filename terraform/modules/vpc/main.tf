resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-${var.ENVIRONMENT}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "public-${var.ENVIRONMENT}"
  }
}

resource "aws_internet_gateway" "gate_way" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "gateway-${var.ENVIRONMENT}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate_way.id
  }

  tags = {
    Name = "public_route_table-${var.ENVIRONMENT}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "master_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "master_sg-${var.ENVIRONMENT}"

  dynamic "ingress" {
    for_each = var.MASTER_INGRESS_RULES
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "worker_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "worker_sg-${var.ENVIRONMENT}"

  dynamic "ingress" {
    for_each = var.WORKER_INGRESS_RULES
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}