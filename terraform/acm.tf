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

resource "aws_acm_certificate" "dev_ssl_cert" {
  domain_name = "voice-dev.allizom.org"

  subject_alternative_names = [
    "commonvoice-dev.allizom.org",
    "dev.commonvoice.mozit.cloud",
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

resource "aws_acm_certificate" "sandbox_ssl_cert" {
  domain_name = "voice-sandbox.allizom.org"

  subject_alternative_names = [
    "sandbox.voice.mozit.cloud",
    "dev.commonvoice.mozit.cloud",
    "sandbox.commonvoice.mozit.cloud",
    "commonvoice-sandbox.allizom.org",
  ]

  tags = {
    Name = "voice-k8s-sandbox"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "stage_ssl_cert" {
  domain_name = "voice.allizom.org"

  subject_alternative_names = [
    "stage.commonvoice.mozit.cloud",
    "stage.voice.mozit.cloud",
    "commonvoice.allizom.org",
  ]

  tags = {
    Name = "voice-k8s-stage"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "prod_ssl_cert" {
  domain_name = "voice.mozilla.org"

  subject_alternative_names = [
    "prod.commonvoice.mozit.cloud",
    "commonvoice.mozilla.org",
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
