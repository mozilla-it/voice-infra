resource "aws_s3_bucket" "kubecost" {
  bucket_prefix = "voice-kubecost-"
}

resource "aws_spot_datafeed_subscription" "default" {
  bucket = "${aws_s3_bucket.kubecost.bucket}"
  prefix = "spot-pricing"
}

data "aws_iam_policy_document" "kubecost_role" {
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

resource "aws_iam_role" "kubecost" {
  name = "kubecost"

  assume_role_policy = "${data.aws_iam_policy_document.kubecost_role.json}"
}

data "aws_iam_policy_document" "kubecost_policy" {
  statement {
    sid = "s3"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = ["${aws_s3_bucket.kubecost.arn}/*"]
  }
}

resource "aws_iam_role_policy" "kubecost" {
  name = "kubecost-role-policy"
  role = "${aws_iam_role.kubecost.id}"

  policy = "${data.aws_iam_policy_document.kubecost_policy.json}"
}
