provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "voice-state-058419420086"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
