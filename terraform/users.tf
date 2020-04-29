resource "aws_iam_user" "rshaw" {
  name = "rshaw"
  path = "/users/"
}

resource "aws_iam_user" "phire" {
  name = "phire"
  path = "/users/"
}

resource "aws_iam_user" "nemo" {
  name = "nemo"
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
        aws_iam_user.rshaw.arn,
        aws_iam_user.phire.arn,
        aws_iam_user.nemo.arn,
      ]
    }
  }
}

resource "aws_iam_role" "developers" {
  name               = "developers"
  assume_role_policy = data.aws_iam_policy_document.developers_assume_role.json
}

resource "aws_iam_user_policy" "rshaw" {
  name = "rshaw"
  user = aws_iam_user.rshaw.name

  policy = data.aws_iam_policy_document.rshaw.json
}

resource "aws_iam_user_policy" "phire" {
  name = "phire"
  user = aws_iam_user.phire.name

  policy = data.aws_iam_policy_document.phire.json
}

resource "aws_iam_user_policy" "nemo" {
  name = "nemo"
  user = aws_iam_user.nemo.name

  policy = data.aws_iam_policy_document.nemo.json
}

resource "aws_iam_role_policy" "developers" {
  name = "developers"
  role = aws_iam_role.developers.name

  policy = data.aws_iam_policy_document.developers.json
}

data "aws_iam_policy_document" "developers" {

  statement {
    sid       = "eks"
    actions   = ["eks:DescribeCluster"]
    resources = ["*"]
  }

  statement {
    sid       = "s3ObjectLevelPermissions"
    resources = ["arn:aws:s3:::voice-*"]
    actions = ["s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectRetention",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectRetention",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
    "s3:RestoreObject"]
  }

  statement {
    sid       = "s3ListBucket"
    resources = ["arn:aws:s3:::*"]
    actions   = ["s3:ListAllMyBuckets", "s3:ListBucket"]
  }

  statement {
    sid       = "redisClusterList"
    resources = ["arn:aws:elasticache:::*"]
    actions   = ["elasticache:DescribeCacheClusters", "elasticache:RebootCacheCluster"]
  }

  statement {
    sid       = "rdsDescribe"
    resources = ["arn:aws:rds:::*"]
    actions   = ["rds:Describe*"]
  }
}

data "aws_iam_policy_document" "rshaw" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      aws_iam_role.developers.arn,
    ]
  }
}

resource "aws_iam_access_key" "rshaw" {
  user    = aws_iam_user.rshaw.name
  pgp_key = "keybase:rileyjshaw"
}

data "aws_iam_policy_document" "phire" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      aws_iam_role.developers.arn
    ]
  }
}

resource "aws_iam_access_key" "phire" {
  user    = aws_iam_user.phire.name
  pgp_key = "keybase:phirework"
}

data "aws_iam_policy_document" "nemo" {
  statement {
    sid = "sts"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      aws_iam_role.developers.arn,
    ]
  }
}

resource "aws_iam_access_key" "nemo" {
  user    = aws_iam_user.nemo.name
  pgp_key = "keybase:nemo"
}

