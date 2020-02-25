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
