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

resource "aws_iam_role" "voice-k8s-prod" {
  name = "voice-k8s-prod"

  assume_role_policy = "${data.aws_iam_policy_document.voice_sts.json}"
}

resource "aws_iam_role" "voice-k8s-stage" {
  name = "voice-k8s-stage"

  assume_role_policy = "${data.aws_iam_policy_document.voice_sts.json}"
}

resource "aws_iam_role" "voice-k8s-dev" {
  name = "voice-k8s-dev"

  assume_role_policy = "${data.aws_iam_policy_document.voice_sts.json}"
}

resource "aws_iam_role" "voice-k8s-sandbox" {
  name = "voice-k8s-sandbox"

  assume_role_policy = "${data.aws_iam_policy_document.voice_sts.json}"
}

data "aws_iam_policy_document" "voice-sandbox" {
  statement {
    sid = "s3"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.voice-sandbox.arn}/*",
      "${aws_s3_bucket.voice-sandbox.arn}",
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "${aws_s3_bucket.voice-sandbox.arn}",
    ]
  }
}

data "aws_iam_policy_document" "voice-stage" {
  statement {
    sid = "s3all"

    # XXX: Read-only on purpose for now
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}/*",
      "${data.aws_s3_bucket.voice-stage.arn}",
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}",
    ]
  }
}

data "aws_iam_policy_document" "voice-dev" {
  statement {
    sid = "s3all"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.voice-dev.arn}/*",
      "${aws_s3_bucket.voice-dev.arn}",
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "${aws_s3_bucket.voice-dev.arn}",
    ]
  }
}

data "aws_iam_policy_document" "voice-prod" {
  statement {
    sid = "s3all"

    #XXX: Read-only on purpose
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-prod.arn}/*",
      "${data.aws_s3_bucket.voice-prod.arn}",
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "${data.aws_s3_bucket.voice-prod.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "voice-prod" {
  name = "voice-k8s-role-policy-${var.cluster_name}-prod"
  role = "${aws_iam_role.voice-k8s-prod.id}"

  policy = "${data.aws_iam_policy_document.voice-prod.json}"
}

resource "aws_iam_role_policy" "voice-sandbox" {
  name = "voice-k8s-role-policy-${var.cluster_name}-sandbox"
  role = "${aws_iam_role.voice-k8s-sandbox.id}"

  policy = "${data.aws_iam_policy_document.voice-sandbox.json}"
}

resource "aws_iam_role_policy" "voice-dev" {
  name = "voice-k8s-role-policy-${var.cluster_name}-dev"
  role = "${aws_iam_role.voice-k8s-dev.id}"

  policy = "${data.aws_iam_policy_document.voice-dev.json}"
}

resource "aws_iam_role_policy" "voice-stage" {
  name = "voice-k8s-role-policy-${var.cluster_name}-stage"
  role = "${aws_iam_role.voice-k8s-stage.id}"

  policy = "${data.aws_iam_policy_document.voice-stage.json}"
}
