data "aws_s3_bucket" "voice-prod" {
  bucket = "voice-prod-clips-393eefd0cba28c270ced0f9587a4f6ae601ca91e"
}

data "aws_s3_bucket" "voice-stage" {
  bucket = "voice-stage-clips-934a7753ac94c18242c82ed71d5088b24b02bdd6"
}
