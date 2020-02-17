variable "region" {
  type    = string
  default = "us-west-2"
}

variable "common-tags" {
  type = map(string)

  default = {
    "cost-center"   = "1410"
    "project-name"  = "voice"
    "project-desc"  = "voice.mozilla.org"
    "project-email" = "it-sre@mozilla.com"
    "deploy-method" = "terraform"
  }
}
