resource "aws_vpc_endpoint" "main_ssm" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ssm.id,
  ]

  subnet_ids = [
    aws_subnet.private_2a.id,
    aws_subnet.private_2c.id,
  ]

  tags = {
    "Name" = "${var.user_id}-vpc-ep-${local.region_code}-main-ssm"
  }
}

resource "aws_vpc_endpoint" "main_ssmmessages" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ssm.id,
  ]

  subnet_ids = [
    aws_subnet.private_2a.id,
    aws_subnet.private_2c.id,
  ]

  tags = {
    "Name" = "${var.user_id}-vpc-ep-${local.region_code}-main-ssmmessages"
  }
}

resource "aws_vpc_endpoint" "main_ec2messages" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ssm.id,
  ]

  subnet_ids = [
    aws_subnet.private_2a.id,
    aws_subnet.private_2c.id,
  ]

  tags = {
    "Name" = "${var.user_id}-vpc-ep-${local.region_code}-main-ec2messages"
  }
}