resource "aws_iam_user" "rshaw" {
  name = "rshaw"
  path = "/users/"
}

resource "aws_iam_user" "alberto" {
  name = "alberto"
  path = "/users/"
}

resource "aws_iam_user" "phire" {
  name = "phire"
  path = "/users/"
}

data "aws_iam_policy_document" "developers_assume_role" {
  statement {
    sid = "devs"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_user.rshaw.arn}",
        "${aws_iam_user.alberto.arn}",
        "${aws_iam_user.phire.arn}",
      ]
    }
  }
}

resource "aws_iam_role" "developers" {
  name = "developers"
  assume_role_policy = "${data.aws_iam_policy_document.developers_assume_role.json}"
}

resource "aws_iam_user_policy" "rshaw" {
  name = "rshaw"
  user = "${aws_iam_user.rshaw.name}"

  policy = "${data.aws_iam_policy_document.rshaw.json}"
}

resource "aws_iam_user_policy" "alberto" {
  name = "alberto"
  user = "${aws_iam_user.alberto.name}"

  policy = "${data.aws_iam_policy_document.rshaw.json}"
}

resource "aws_iam_user_policy" "phire" {
  name = "phire"
  user = "${aws_iam_user.phire.name}"

  policy = "${data.aws_iam_policy_document.phire.json}"
}

resource "aws_iam_role_policy" "developers" {
  name = "developers"
  role = "${aws_iam_role.developers.name}"

  policy = "${data.aws_iam_policy_document.developers.json}"
}

data "aws_iam_policy_document" "developers" {

  statement {
    sid = "eks"
    actions = [ "eks:DescribeCluster" ]
    resources = [ "*" ]
  }
}

data "aws_iam_policy_document" "rshaw" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "${aws_iam_role.developers.arn}",
    ]
  }

  statement {
    sid = "eks"
    actions = [ "eks:DescribeCluster" ]
    resources = [ "*" ]
  }
}

resource "aws_iam_access_key" "rshaw" {
  user = "${aws_iam_user.rshaw.name}"
}

data "aws_iam_policy_document" "alberto" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "${aws_iam_role.developers.arn}",
    ]
  }
}

resource "aws_iam_access_key" "alberto" {
  user    = "${aws_iam_user.alberto.name}"
	pgp_key = "keybase:adelbarrio"
}

data "aws_iam_policy_document" "phire" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "${aws_iam_role.developers.arn}",
    ]
  }

  statement {
    sid = "eks"
    actions = [ "eks:DescribeCluster" ]
    resources = [ "*" ]
  }
}

resource "aws_iam_access_key" "phire" {
  user = "${aws_iam_user.phire.name}"
	pgp_key = "keybase:phirework"
}

