# main VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.user_id}-vpc-${local.region_code}-main"
  }

}


# main Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.user_id}-igw-${local.region_code}-main"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id = aws_subnet.public_2c.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.user_id}-natgw-${local.region_code}-pub-2c"
  }
}

resource "aws_eip" "natgw" {
  vpc   = true
  lifecycle {
    create_before_destroy = true
  }
    tags = {
    Name = "${var.user_id}-eip-natgw-${local.region_code}-pub-2c"
  }
}


# public 2a subnet
resource "aws_subnet" "public_2a" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.0/26"
  availability_zone = "${var.aws_region}a"

  tags = {
    "Name" = "${var.user_id}-sbn-${local.region_code}-pub-2a"
  }
}

resource "aws_route_table" "public_2a" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.user_id}-rtb-${local.region_code}-pub-2a"
  }
}

resource "aws_route_table_association" "public_2a" {
  subnet_id = aws_subnet.public_2a.id
  route_table_id = aws_route_table.public_2a.id
}


# public 2c subnet
resource "aws_subnet" "public_2c" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.64/26"
  availability_zone = "${var.aws_region}c"

  tags = {
    "Name" = "${var.user_id}-sbn-${local.region_code}-pub-2c"
  }
}

resource "aws_route_table" "public_2c" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.user_id}-rtb-${local.region_code}-pub-2c"
  }
}

resource "aws_route_table_association" "public_2c" {
  subnet_id = aws_subnet.public_2c.id
  route_table_id = aws_route_table.public_2c.id
}


# private 2a subnet
resource "aws_subnet" "private_2a" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.128/26"
  availability_zone = "${var.aws_region}a"

  tags = {
    "Name" = "${var.user_id}-sbn-${local.region_code}-pri-2a"
  }
}

resource "aws_route_table" "private_2a" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.user_id}-rtb-${local.region_code}-pri-2a"
  }
}

resource "aws_route_table_association" "private_2a" {
  subnet_id = aws_subnet.private_2a.id
  route_table_id = aws_route_table.private_2a.id
}


# private 2c subnet
resource "aws_subnet" "private_2c" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.192/26"
  availability_zone = "${var.aws_region}c"

  tags = {
    "Name" = "${var.user_id}-sbn-${local.region_code}-pri-2c"
  }
}

resource "aws_route_table" "private_2c" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.user_id}-rtb-${local.region_code}-pri-2c"
  }
}

resource "aws_route_table_association" "private_2c" {
  subnet_id = aws_subnet.private_2c.id
  route_table_id = aws_route_table.private_2c.id
}

# security group for ssm
resource "aws_security_group" "ssm" {
  name        = "${var.user_id}-scg-ec2-${local.region_code}-ssm"
  description = "ssm Sg for access"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.user_id}-scg-ec2-${local.region_code}-ssm"
  }
}

resource "aws_security_group_rule" "allow_inbound_https_ssm" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [ aws_vpc.main.cidr_block ]
  description = "https from vpc"

  security_group_id = aws_security_group.ssm.id
}
