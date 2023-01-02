resource "aws_route53_zone" "scott1_ml" {
  name = "scott1.ml"
}

resource "aws_route53_record" "gitlab_scott1_ml" {
  zone_id = aws_route53_zone.scott1_ml.zone_id
  name    = "gitlab.scott1.ml"
  type    = "A"

  alias {
    name = format("%s.%s", "dualstack", module.main.lb_dns_name)
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins_scott1_ml" {
  zone_id = aws_route53_zone.scott1_ml.zone_id
  name    = "jenkins.scott1.ml"
  type    = "A"

  alias {
    name = format("%s.%s", "dualstack", module.main.lb_dns_name)
    zone_id                = module.main.lb_zone_id
    evaluate_target_health = true
  }
}