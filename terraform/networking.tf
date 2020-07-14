locals {
  vpc_cidr = "10.50.0.0/16"
  subnet_numbers = {
    "ap-northeast-1a" = 0
    "ap-northeast-1c" = 1
  }
}

resource "aws_vpc" "collarks" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}

resource "aws_subnet" "collarks_public" {
  for_each          = local.subnet_numbers
  vpc_id            = aws_vpc.collarks.id
  cidr_block        = cidrsubnet(aws_vpc.collarks.cidr_block, 8, each.value)
  availability_zone = each.key
}

resource "aws_internet_gateway" "collarks_gw" {
  vpc_id = aws_vpc.collarks.id
}

resource "aws_route_table" "collarks_public_rt" {
  vpc_id = aws_vpc.collarks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.collarks_gw.id
  }
}

resource "aws_route_table_association" "collarks_public_rt_asc" {
  for_each       = local.subnet_numbers
  route_table_id = aws_route_table.collarks_public_rt.id
  subnet_id      = aws_subnet.collarks_public[each.key].id
}

resource "aws_security_group" "collarks_lb" {
  vpc_id      = aws_vpc.collarks.id
  name        = "collarks-alb"
  description = "collarks-alb"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "collarks_service" {
  vpc_id      = aws_vpc.collarks.id
  name        = "collarks-service"
  description = "collarks-service"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

