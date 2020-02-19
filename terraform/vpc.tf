locals {
  vpc-tags = {
    Name   = "voice-prod"
    Region = "us-west-2"
  }
}

module "vpc" {
  # TODO: change source to upstream once PR#3 is merged
  source = "github.com/mozilla-it/terraform-modules//vpc?ref=ab04f153857c058f361b38c97eea8029bd3c05ea"
  region = "us-west-2"
  name   = "voice-prod"
  tags   = merge(var.common-tags, local.vpc-tags)
}
