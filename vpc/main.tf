locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "vpc"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-main-vpc" }
  )
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-public-subnet-${count.index + 1}" }
  )
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-private-subnet-${count.index + 1}" }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-igw" }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-public-route-table" }
  )
}

resource "aws_route_table_association" "public_subnets_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "ngw_eip" {
  count  = length(var.private_subnets)
  domain = "vpc"

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-public-ngw-eip-${count.index + 1}" }
  )
}

resource "aws_nat_gateway" "public_ngw" {
  count             = length(var.private_subnets)
  allocation_id     = aws_eip.ngw_eip[count.index].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnets[count.index].id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-public-ngw-${count.index + 1}" }
  )
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_ngw[count.index].id
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-private-route-table-${count.index + 1}" }
  )
}

resource "aws_route_table_association" "private_subnets_association" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.prefix}-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = local.common_tags
}

resource "aws_security_group" "rds_sg" {
  name        = "${local.prefix}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = local.common_tags
}

resource "aws_security_group" "ecs_sg" {
  name        = "${local.prefix}-ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  tags = local.common_tags
}