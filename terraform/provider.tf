provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  # Needed for Cloudfront SSL cert
  region = "us-east-1"
  alias  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "voice-state-058419420086"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
