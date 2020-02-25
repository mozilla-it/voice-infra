data "aws_route53_zone" "voice_mozit_cloud" {
  name = "voice.mozit.cloud"
}

data "aws_elb" "dev" {
  name = "a173022d857d011eabf210a8061d9461"
}

resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.voice_mozit_cloud.zone_id
  name    = "dev.voice.mozit.cloud"
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_elb.dev.dns_name}"
    zone_id                = data.aws_elb.dev.zone_id
    evaluate_target_health = false
  }
}

data "aws_elb" "sandbox" {
  name = "a244190cd57d811eabf210a8061d9461"
}

resource "aws_route53_record" "sandbox" {
  zone_id = data.aws_route53_zone.voice_mozit_cloud.zone_id
  name    = "sandbox.voice.mozit.cloud"
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_elb.sandbox.dns_name}"
    zone_id                = data.aws_elb.sandbox.zone_id
    evaluate_target_health = false
  }
}
