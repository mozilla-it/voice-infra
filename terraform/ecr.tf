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
  source      = "github.com/mozilla-it/terraform-modules//aws/ecr?ref=master"
  repo_name   = "remote_syslog2"
  create_user = false
}

module "db-monitor-ecr" {
  source      = "github.com/mozilla-it/terraform-modules//aws/ecr?ref=master"
  repo_name   = "db-monitor"
  create_user = false
}
