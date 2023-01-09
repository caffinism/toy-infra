resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  validation_option {
    domain_name       = "${var.domain}"
    validation_domain = "${var.domain}"
  }
}