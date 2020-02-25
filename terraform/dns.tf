data "aws_route53_zone" "voice_mozit_cloud" {
  name = "voice.mozit.cloud"
}

data "aws_elb" "dev_elb" {
  name = "a173022d857d011eabf210a8061d9461"
}

resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.voice_mozit_cloud.zone_id
  name    = "dev.voice.mozit.cloud"
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_elb.dev_elb.dns_name}"
    zone_id                = data.aws_elb.dev_elb.zone_id
    evaluate_target_health = false
  }
}
