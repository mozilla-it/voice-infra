resource "aws_s3_bucket" "velero" {
  bucket_prefix = "velero-voice-prod-"
  acl           = "private"
  region        = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.velero.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "velero_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:velero:velero-server"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "velero" {
  name               = "velero"
  assume_role_policy = data.aws_iam_policy_document.velero_role.json
}

data "aws_iam_policy_document" "velero_policy" {
  statement {
    sid = "ec2"

    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "s3"

    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:GetObject",
    ]

    resources = ["${aws_s3_bucket.velero.arn}/*"]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.velero.arn]
  }

  statement {
    sid = "kmskeys"

    actions = [
      "kms:ListKeys",
      "kms:ListAliases",
    ]

    resources = ["*"]
  }

  statement {
    sid = "kms"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = [
      aws_kms_key.velero.arn,
    ]
  }
}

resource "aws_iam_role_policy" "velero" {
  name = "velero-role-policy-voice-prod"
  role = aws_iam_role.velero.id

  policy = data.aws_iam_policy_document.velero_policy.json
}

resource "aws_kms_key" "velero" {
  description = "This key is used by Velero for encrypt/decrypt Kubernetes backups"
}

# This alias provides a name to the key. It will be displayed in the AWS console
resource "aws_kms_alias" "velero" {
  name          = "alias/velero"
  target_key_id = aws_kms_key.velero.key_id
}
