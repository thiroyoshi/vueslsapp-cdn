resource "aws_route53_record" "vueslsapp" {
  zone_id = var.route53_zone_id
  name    = join(".", [var.project_name, var.domain])
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.vueslsapp.domain_name
    zone_id                = aws_cloudfront_distribution.vueslsapp.hosted_zone_id
    evaluate_target_health = false
  }
}