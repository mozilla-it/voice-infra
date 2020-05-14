data "aws_s3_bucket" "voice-prod" {
  bucket = "voice-prod-clips-393eefd0cba28c270ced0f9587a4f6ae601ca91e"
}

data "aws_s3_bucket" "voice-stage" {
  bucket = "voice-stage-clips-934a7753ac94c18242c82ed71d5088b24b02bdd6"
}

resource "aws_s3_bucket" "voice-dev" {
  bucket = "voice-dev-clips-20191211013626583200000002"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://dev.voice.mozit.cloud"]
    max_age_seconds = 0
  }
}

resource "aws_s3_bucket" "voice-sandbox" {
  bucket = "voice-sandbox-clips-20191211013626583100000001"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://sandbox.voice.mozit.cloud"]
    max_age_seconds = 0
  }
}
