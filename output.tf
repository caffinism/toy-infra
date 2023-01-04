# need to manage nameservers for ${var.domain} from freenom.com
output "name_servers"{
  value = aws_route53_zone.domain.name_servers
  description = "need to manage nameservers for ${var.domain} from freenom.com"
}