data "aws_db_instance" "voice-prod" {
  db_instance_identifier = "voice-prod"
}

data "aws_db_instance" "voice-stage" {
  db_instance_identifier = "voice-stage"
}
