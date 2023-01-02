locals {

  # ap-northeast-2 => an2
  region_code = join("", [
    for token in split("-", var.aws_region): substr(token, 0, 1)
  ])

}