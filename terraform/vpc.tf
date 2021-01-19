locals {
  vpc-tags = {
    "Name"                             = "voice-prod"
    "Region"                           = "us-west-2"
    "kubernetes.io/cluster/voice-prod" = "shared"
  }
}

module "vpc" {
  source = "github.com/mozilla-it/terraform-modules//aws/vpc?ref=master"
  region = "us-west-2"
  name   = "voice-prod"
  tags   = merge(var.common-tags, local.vpc-tags)
}
