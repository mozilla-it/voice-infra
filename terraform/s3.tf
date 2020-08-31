data "aws_s3_bucket" "voice-prod" {
  bucket = "voice-prod-clips-393eefd0cba28c270ced0f9587a4f6ae601ca91e"
}

data "aws_s3_bucket" "voice-stage" {
  bucket = "voice-stage-clips-934a7753ac94c18242c82ed71d5088b24b02bdd6"
}

data "aws_s3_bucket" "voice_bundler_stage" {
  bucket = "voice-stage-bundler-b48466793fa3bc69b1a8b77d6456532fd376be66"
}

resource "aws_s3_bucket" "voice-dev" {
  bucket = "voice-dev-clips-20191211013626583200000002"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://dev.voice.mozit.cloud", "https://voice-dev.allizom.org"]
    max_age_seconds = 0
  }
}

resource "aws_s3_bucket" "voice-sandbox" {
  bucket = "voice-sandbox-clips-20191211013626583100000001"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://sandbox.voice.mozit.cloud", "https://voice-sandbox.allizom.org"]
    max_age_seconds = 0
  }
}

resource "aws_s3_bucket" "voice-permalink" {
  # This bucket contains old corpus datasets which we must keep
  # because some papers are referencing it.
  # Moved from legacy account 763061450761
  bucket = "common-voice-data-download"
  acl    = "public-read"
}
