# gitlab ec2
resource "aws_instance" "gitlab" {
  ami = "${var.gitlab_ami}" # amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2
  instance_type = "${var.gitlab_instance_type}"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.id
  vpc_security_group_ids      = [aws_security_group.gitlab.id]
  availability_zone           = "${var.aws_region}c"
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private_2c.id

  user_data = templatefile("${path.module}/scripts/user-data.sh", {
    service_name = "gitlab"
  })

  tags ={
    Name = "${var.user_id}-ec2-${local.region_code}-gitlab"
  }

  depends_on = [
    aws_nat_gateway.natgw,
    aws_route.private-2c-igw
  ]
}

resource "aws_security_group" "gitlab" {
  name        = "${var.user_id}-scg-ec2-${local.region_code}-gitlab"
  description = "gitlab Sg for access"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.user_id}-scg-ec2-${local.region_code}-gitlab"
  }
}

resource "aws_security_group_rule" "allow_inbound_custom_gitlab" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.alb.id
  description = "http from alb"

  security_group_id = aws_security_group.gitlab.id
}

resource "aws_security_group_rule" "allow_outbound_custom_gitlab" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "gitlab to internet"

  security_group_id = aws_security_group.gitlab.id
}


# jenkins ec2
resource "aws_instance" "jenkins" {
  ami = "${var.jenkins_ami}" # amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2
  instance_type = "${var.jenkins_instance_type}"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  availability_zone           = "${var.aws_region}a"
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private_2a.id

  user_data = templatefile("${path.module}/scripts/user-data.sh", {
    service_name = "jenkins"
  })

  tags ={
    Name = "${var.user_id}-ec2-${local.region_code}-jenkins"
  }

  depends_on = [
    aws_nat_gateway.natgw,
    aws_route.private-2a-igw
  ]
}

resource "aws_security_group" "jenkins" {
  name        = "${var.user_id}-scg-ec2-${local.region_code}-jenkins"
  description = "jenkins Sg for access"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.user_id}-scg-ec2-${local.region_code}-jenkins"
  }
}

resource "aws_security_group_rule" "allow_inbound_custom_jenkins" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.alb.id
  description = "http from alb"

  security_group_id = aws_security_group.jenkins.id
}

resource "aws_security_group_rule" "allow_inbound_custom_jenkins_2" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  source_security_group_id = aws_security_group.alb.id
  description = "http from alb"

  security_group_id = aws_security_group.jenkins.id
}

resource "aws_security_group_rule" "allow_outbound_custom_gjenkins" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "jenkins to internet"

  security_group_id = aws_security_group.jenkins.id
}


# ec2 iam instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.user_id}-ec2-${local.region_code}-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.user_id}-role-ec2-${local.region_code}"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
  tags = {
    Name = "${var.user_id}-role-ec2-${local.region_code}"
  }
}