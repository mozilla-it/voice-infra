module "devs_ro" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-devs-ro"
  role_mapping = ["voice-dev"]
  policy_arn   = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

module "devs_role" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-devs-rw"
  role_mapping = ["voice-dev"]
  policy_arn   = aws_iam_policy.devs_policy.arn
}

resource "aws_iam_policy" "devs_policy" {
  name   = "voiceDevelopersPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.devs_policy.json
}

data "aws_iam_policy_document" "devs_policy" {

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
}
