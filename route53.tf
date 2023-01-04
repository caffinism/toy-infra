resource "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

resource "aws_route53_record" "gitlab_domain" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "gitlab.${var.domain}"
  type    = "A"

  alias {
    name = format("%s.%s", "dualstack", module.main.lb_dns_name)
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins_domain" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "jenkins.${var.domain}"
  type    = "A"

  alias {
    name = format("%s.%s", "dualstack", module.main.lb_dns_name)
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}