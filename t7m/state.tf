terraform {
  backend "s3" {
    bucket = "public-state-00965c5580ca916ea887d10f70"
    key    = "k8s/aws/us-west-2/voice"
    region = "eu-west-1"
  }
}
