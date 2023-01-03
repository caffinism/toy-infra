# alb main
module "main" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  name = "${var.user_id}-alb-${local.region_code}-main"

  load_balancer_type = "application"

  vpc_id             = aws_vpc.main.id
  subnets            = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2c.id,
    ]
  security_groups    = [
    aws_security_group.alb.id,
    ]

  target_groups = [
    {
      name             = "${var.user_id}-alb-tg-${local.region_code}-gitlab"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      protocol_version = "HTTP1"
      health_check = {
          enabled             = true
          path                = "/"
          protocol            = "HTTP"
      }
      targets = {
        my_target = {
          target_id = aws_instance.gitlab.id
          port = 80
        }
      }
      tags = {
        Name = "${var.user_id}-alb-tg-${local.region_code}-gitlab"
      }
    },
    {
      name             = "${var.user_id}-alb-tg-${local.region_code}-jenkins"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      protocol_version = "HTTP1"
      health_check = {
          enabled             = true
          path                = "/"
          protocol            = "HTTP"
      }
      targets = {
        my_target = {
          target_id = aws_instance.jenkins.id
          port = 80
        }
      }
      tags = {
        Name = "${var.user_id}-alb-tg-${local.region_code}-jenkins"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port = 80
      protocol = "HTTP"
      target_group_index = 0
    },
  ]

  http_tcp_listener_rules = [
      {
          # gitlab
          http_tcp_listener_index = 0
          priority                = 1
          actions = [{
              type         = "forward"
              target_group_index = 0
          }]
          conditions = [
              {
                  path_patterns = ["/*"]
              },
              {
                  host_headers = ["gitlab.scott1.ml"]
              }
          ]
      },
      {
          # jenkins
          http_tcp_listener_index = 0
          priority                = 2
          actions = [{
              type         = "forward"
              target_group_index = 1
          }]
          conditions = [
              {
                  path_patterns = ["/*"]
              },
              {
                  host_headers = ["jenkins.scott1.ml"]
              }
          ]
      },
  ]

}

# security group for alb
resource "aws_security_group" "alb" {
  name        = "${var.user_id}-scg-ec2-${local.region_code}-alb"
  description = "alb Sg for access"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.user_id}-scg-${local.region_code}-alb"
  }
}

resource "aws_security_group_rule" "allow_inbound_custom_alb" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [
    "27.122.140.10/32",
    "${aws_eip.natgw.public_ip}/32"
    ]
  description = "gitlab, jenkins from internet"

  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "allow_outbound_custom_alb" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "gitlab, jenkins to internet"

  security_group_id = aws_security_group.alb.id
}