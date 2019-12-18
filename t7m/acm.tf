resource "aws_acm_certificate" "dev" {
  domain_name       = "voice-dev.allizom.org"
  validation_method = "DNS"

  tags {
    Name = "voice-k8s-dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "sandbox" {
  domain_name = "voice-sandbox.allizom.org"

  tags {
    Name = "voice-k8s-sandbox"
  }

  validation_method = "DNS"
}

resource "aws_acm_certificate" "stage" {
  domain_name = "voice.allizom.org"

  tags {
    Name = "voice-k8s-stage"
  }

  validation_method = "DNS"
}

resource "aws_acm_certificate" "prod" {
  domain_name = "voice.mozilla.org"

  tags {
    Name = "voice-k8s-prod"
  }

  validation_method = "DNS"
}
