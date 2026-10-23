data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_az = coalesce(var.availability_zone, data.aws_availability_zones.available.names[0])
  vpc_id      = var.create_network ? aws_vpc.app[0].id : var.vpc_id
  subnet_id   = var.create_network ? aws_subnet.public[0].id : var.subnet_id
}

resource "aws_vpc" "app" {
  count                = var.create_network ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "flask-app-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "app" {
  count  = var.create_network ? 1 : 0
  vpc_id = aws_vpc.app[0].id

  tags = {
    Name        = "flask-app-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count                   = var.create_network ? 1 : 0
  vpc_id                  = aws_vpc.app[0].id
  cidr_block              = var.subnet_cidr
  availability_zone       = local.selected_az
  map_public_ip_on_launch = true

  tags = {
    Name        = "flask-app-public-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  count  = var.create_network ? 1 : 0
  vpc_id = aws_vpc.app[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app[0].id
  }

  tags = {
    Name        = "flask-app-public-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = var.create_network ? 1 : 0
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public[0].id
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  allowed_app_cidrs = var.allowed_app_cidrs
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  environment       = var.environment
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = local.subnet_id
  vpc_id            = local.vpc_id
}
