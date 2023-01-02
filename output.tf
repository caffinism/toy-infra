# need to manage nameservers for scott.ml from freenom.com
output "name_servers"{
  value = aws_route53_zone.scott1_ml.name_servers
  description = "need to manage nameservers for scott.ml from freenom.com"
}