data "aws_iam_policy_document" "voice_sts" {
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

resource "aws_iam_role" "voice" {
  name = "voice-k8s"

  assume_role_policy = "${data.aws_iam_policy_document.voice_sts.json}"
}

data "aws_iam_policy_document" "voice" {
  statement {
    sid = "s3"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}/*",
      "${data.aws_s3_bucket.voice-stage.arn}",
      "${data.aws_s3_bucket.voice-prod.arn}/*",
      "${data.aws_s3_bucket.voice-prod.arn}",
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}",
      "${data.aws_s3_bucket.voice-prod.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "voice" {
  name = "voice-k8s-role-policy-${var.cluster_name}"
  role = "${aws_iam_role.voice.id}"

  policy = "${data.aws_iam_policy_document.voice.json}"
}
