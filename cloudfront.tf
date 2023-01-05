resource "aws_cloudfront_diftribution" "s3_fe" {

  origin {
    domain_name              = aws_s3_bucket.fe.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_fe.id
    origin_id                = "scott-origin"
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["${var.domain}", ]

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["KR",]
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
  }

}

resource "aws_cloudfront_origin_access_control" "s3_fe" {
  name                              = "${aws_s3_bucket.fe.bucket_regional_domain_name}"
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}