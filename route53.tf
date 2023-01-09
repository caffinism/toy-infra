resource "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

resource "aws_route53_record" "gitlab_domain" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "gitlab.${var.domain}"
  type    = "A"

  alias {
    name = "${module.main.lb_dns_name}"
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins_domain" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "jenkins.${var.domain}"
  type    = "A"

  alias {
    name = "${module.main.lb_dns_name}"
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = aws_route53_zone.domain.zone_id
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  allow_overwrite = true

}

resource "aws_route53_record" "cloudfront" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_fe.domain_name
    zone_id                = aws_cloudfront_distribution.s3_fe.hosted_zone_id
    evaluate_target_health = true
  }

}