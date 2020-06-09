resource "aws_ecr_repository" "ecr" {
  name = "voice"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "go-mysql-elasticsearch" {
  name = "go-mysql-elasticsearch"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "common-voice-bundler" {
  name = "common-voice-bundler"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "ecr" {
  source      = "github.com/mozilla-it/terraform-modules//aws/ecr?ref=5df4a370339b04193938a5d3455015c0e1c6b247"
  repo_name   = "remote_syslog2"
  create_user = false
}
