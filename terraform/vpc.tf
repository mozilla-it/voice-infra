locals {
  vpc-tags = {
    Name   = "voice-prod"
    Region = "us-west-2"
  }
}

module "vpc" {
  source = "github.com/mozilla-it/terraform-modules//vpc?ref=3c817675f294eb73ca4cd3764bedf73ad57a2d00"
  region = "us-west-2"
  name   = "voice-prod"
  tags   = merge(var.common-tags, local.vpc-tags)
}
