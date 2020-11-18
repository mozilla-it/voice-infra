resource "aws_cloudfront_distribution" "stage" {
  origin {
    domain_name = data.aws_s3_bucket.voice_bundler_stage.bucket_regional_domain_name
    origin_id   = "voice-origin-stage"
  }
  depends_on = [
    aws_acm_certificate.cdn_stage,
    aws_acm_certificate_validation.cdn_stage,
  ]

  enabled         = true
  is_ipv6_enabled = true

  aliases = [local.cdn_stage_url]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "voice-origin-stage"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  tags = {
    Environment = "stage"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cdn_stage.arn
    ssl_support_method  = "sni-only"
  }
}


resource "aws_cloudfront_distribution" "prod" {
  origin {
    domain_name = data.aws_s3_bucket.voice_bundler_prod.bucket_regional_domain_name
    origin_id   = "voice-origin-prod"
  }
  depends_on = [
    aws_acm_certificate.cdn_prod,
    aws_acm_certificate_validation.cdn_prod,
  ]

  enabled         = true
  is_ipv6_enabled = true

  aliases = [local.cdn_prod_url]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "voice-origin-prod"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  tags = {
    Environment = "prod"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cdn_prod.arn
    ssl_support_method  = "sni-only"
  }
}
