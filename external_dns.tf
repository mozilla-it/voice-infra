data "aws_iam_policy_document" "external_dns_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    principals {
      type = "AWS"

      identifiers = [
        "${module.k8s.worker_iam_role_arn}",
      ]
    }
  }
}

resource "aws_iam_role" "external_dns" {
  name = "external-dns"

  assume_role_policy = "${data.aws_iam_policy_document.external_dns_role.json}"
}

data "aws_iam_policy_document" "external_dns_policy" {
  statement {
    sid = "alter"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    sid = "read"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "external_dns" {
  name = "external-dns-role-policy"
  role = "${aws_iam_role.external_dns.id}"

  policy = "${data.aws_iam_policy_document.external_dns_policy.json}"
}
