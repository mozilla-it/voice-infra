resource "aws_acm_certificate" "dev" {
  domain_name = "voice-dev.allizom.org"

  subject_alternative_names = [
    "dev.voice.mozit.cloud",
  ]

  validation_method = "DNS"

  tags = {
    Name = "voice-k8s-dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "sandbox" {
  domain_name = "voice-sandbox.allizom.org"

  subject_alternative_names = [
    "sandbox.voice.mozit.cloud",
  ]

  tags = {
    Name = "voice-k8s-sandbox"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "stage" {
  domain_name = "voice.allizom.org"

  subject_alternative_names = [
    "stage.voice.mozit.cloud",
  ]

  tags = {
    Name = "voice-k8s-stage"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "prod" {
  domain_name = "voice.mozilla.org"

  subject_alternative_names = [
    "prod.voice.mozit.cloud",
  ]

  tags = {
    Name = "voice-k8s-prod"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "stats" {
  domain_name = "stats.voice.mozit.cloud"

  tags = {
    Name = "stats-voice"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

#
# Common Voice SSL Certificates and validations
#

# Dev

resource "aws_acm_certificate" "dev_ssl_cert" {
  domain_name = "dev.commonvoice.allizom.org"

  subject_alternative_names = [
    "dev.voice.mozit.cloud",
    "voice-dev.allizom.org",
  ]

  validation_method = "DNS"

  tags = {
    Name = "commonvoice-dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dev_validation" {
  name    = aws_acm_certificate.dev_ssl_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.dev_ssl_cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.commonvoice_allizom_org.zone_id
  records = [aws_acm_certificate.dev_ssl_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

# Sandbox

resource "aws_acm_certificate" "sandbox_ssl_cert" {
  domain_name = "sandbox.commonvoice.allizom.org"

  subject_alternative_names = [
    "sandbox.voice.mozit.cloud",
    "voice-sandbox.allizom.org",
  ]

  tags = {
    Name = "commonvoice-sandbox"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "sandbox_validation" {
  name    = aws_acm_certificate.sandbox_ssl_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.sandbox_ssl_cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.commonvoice_allizom_org.zone_id
  records = [aws_acm_certificate.sandbox_ssl_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

# Stage

resource "aws_acm_certificate" "stage_ssl_cert" {
  domain_name = "commonvoice.allizom.org"

  subject_alternative_names = [
    "voice.allizom.org",
    "stage.voice.mozit.cloud",
  ]

  tags = {
    Name = "commonvoice-stage"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "stage_validation" {
  name    = aws_acm_certificate.stage_ssl_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.stage_ssl_cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.commonvoice_allizom_org.zone_id
  records = [aws_acm_certificate.stage_ssl_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

# Prod
resource "aws_acm_certificate" "prod_ssl_cert" {
  domain_name = "commonvoice.mozilla.org"

  subject_alternative_names = [
    "prod.voice.mozit.cloud",
    "voice.mozilla.org",
  ]

  tags = {
    Name = "commonvoice-prod"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "prod_validation" {
  name    = aws_acm_certificate.prod_ssl_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.prod_ssl_cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.commonvoice_mozilla_org.zone_id
  records = [aws_acm_certificate.prod_ssl_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
