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
  zone_id = aws_route53_zone.domain.zone_id
  name    = "${aws_acm_certificate.cert.resource_record_name}"
  type    = "${aws_acm_certificate.cert.resource_record_type}"
  records = ["${aws_acm_certificate.cert.resource_record_value}", ]
}