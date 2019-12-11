data terraform_remote_state "vpc" {
  backend = "s3"

  config {
    bucket = "public-state-00965c5580ca916ea887d10f70"
    key    = "aws/${var.region}/core.tfstate"
    region = "eu-west-1"
  }
}

data "aws_vpc" "us-west-2" {
  id = "${data.terraform_remote_state.vpc.vpc_id}"
}
