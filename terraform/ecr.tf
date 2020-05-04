resource "aws_ecr_repository" "ecr" {
  name                 = "voice"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "go-mysql-elasticsearch" {
  name                 = "go-mysql-elasticsearch"

  image_scanning_configuration {
    scan_on_push = true
  }
}

