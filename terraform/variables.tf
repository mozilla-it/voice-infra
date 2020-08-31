variable "region" {
  type    = string
  default = "us-west-2"
}

variable "common-tags" {
  type = map(string)

  default = {
    "cost-center"   = "1003"
    "project-name"  = "voice"
    "project-desc"  = "voice.mozilla.org"
    "project-email" = "it-sre@mozilla.com"
    "deploy-method" = "terraform"
  }
}

variable "cdn_stage_url" {
  type    = string
  default = "cdn.commonvoice.allizom.org"
}
variable "cdn_prod_url" {
  type    = string
  default = "cdn.commonvoice.mozilla.org"
}
