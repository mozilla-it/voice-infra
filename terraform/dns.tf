data "aws_elb" "prod" {
  name = "a76fbf07b9cd24da78d0ee6d9dc642d7"
}

resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.voice_mozit_cloud.zone_id
  name    = "prod.voice.mozit.cloud"
  type    = "A"

  alias {
    name                   = data.aws_elb.prod.dns_name
    zone_id                = data.aws_elb.prod.zone_id
    evaluate_target_health = false
  }
}

data "aws_elb" "stage" {
  name = "a482a9da4639011eaade802c1d0948f2"
}

resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.voice_mozit_cloud.zone_id
  name    = "stage.voice.mozit.cloud"
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_elb.stage.dns_name}"
    zone_id                = data.aws_elb.stage.zone_id
    evaluate_target_health = false
  }
}

data "aws_elb" "dev" {
  name = "abfff7c3a181b427f8562c769e84e7ab"
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

data "aws_route53_zone" "voice_mozit_cloud" {
  name = "voice.mozit.cloud"
}
