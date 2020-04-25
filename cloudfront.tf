resource "aws_cloudfront_distribution" "vueslsapp" {
  origin {
    domain_name = join("-", [var.environment, join(".", [var.project_name, var.domain, "s3.amazonaws.com"])])
    origin_id   = join("-", [var.environment, join(".", [var.project_name, var.domain])])

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.vueslsapp.cloudfront_access_identity_path
    }
  }

  aliases             = [join(".", [var.project_name, var.domain])]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.project_name
  default_root_object = "index.html"
  price_class         = "PriceClass_200"
  retain_on_delete    = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = join("-", [var.environment, join(".", [var.project_name, var.domain])])

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  logging_config {
    include_cookies = false
    bucket          = join(".", [aws_s3_bucket.vueslsapp-cf-log.bucket, "s3.amazonaws.com"])
    prefix          = var.project_name
  }

  tags = {
    PROJECT = var.project_name
  }
}

resource "aws_cloudfront_origin_access_identity" "vueslsapp" {
  comment = join("-", [var.environment, join(".", [var.project_name, var.domain])])
}
