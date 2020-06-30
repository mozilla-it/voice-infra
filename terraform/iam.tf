# Dev
resource "aws_iam_role" "voice-dev" {
  name               = "voice-web-dev"
  path               = "/voice/"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role_dev.json
}

data "aws_iam_policy_document" "allow_assume_role_dev" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:voice-dev:voice-dev"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "voice-dev" {
  name = "voice-web-dev"
  role = aws_iam_role.voice-dev.id

  policy = data.aws_iam_policy_document.voice_dev.json
}

data "aws_iam_policy_document" "voice_dev" {
  statement {
    sid = "voiceDevAllowSSM"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:us-west-2:058419420086:parameter/voice/dev/*"]
  }

  statement {
    sid = "voiceDevAllowKMS"

    actions = ["kms:Decrypt"]

    resources = ["${aws_kms_key.voice-dev.arn}"]
  }

  statement {
    sid = "voiceDevS3"

    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.voice-dev.arn}/*",
      "${aws_s3_bucket.voice-dev.arn}",
    ]
  }
}

# sandbox
resource "aws_iam_role" "voice-sandbox" {
  name               = "voice-web-sandbox"
  path               = "/voice/"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role_sandbox.json
}

data "aws_iam_policy_document" "allow_assume_role_sandbox" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:voice-sandbox:voice-sandbox"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "voice-sandbox" {
  name = "voice-web-sandbox"
  role = aws_iam_role.voice-sandbox.id

  policy = data.aws_iam_policy_document.voice_sandbox.json
}

data "aws_iam_policy_document" "voice_sandbox" {
  statement {
    sid = "voiceSandboxAllowSSM"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:us-west-2:058419420086:parameter/voice/sandbox/*"]
  }

  statement {
    sid = "voiceSandboxAllowKMS"

    actions = ["kms:Decrypt"]

    resources = ["${aws_kms_key.voice-sandbox.arn}"]
  }

  statement {
    sid = "voiceSandboxS3"

    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.voice-sandbox.arn}/*",
      "${aws_s3_bucket.voice-sandbox.arn}",
    ]
  }
}

# stage
resource "aws_iam_role" "voice-stage" {
  name               = "voice-web-stage"
  path               = "/voice/"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role_stage.json
}

data "aws_iam_policy_document" "allow_assume_role_stage" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:voice-stage:voice-stage"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "voice-stage" {
  name   = "voice-web-stage"
  role   = aws_iam_role.voice-stage.id
  policy = data.aws_iam_policy_document.voice_stage.json
}

data "aws_iam_policy_document" "voice_stage" {
  statement {
    sid = "voiceStageAllowSSM"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:us-west-2:058419420086:parameter/voice/stage/*"]
  }

  statement {
    sid = "voiceStageAllowKMS"

    actions = ["kms:Decrypt"]

    resources = ["${aws_kms_key.voice-stage.arn}"]
  }

  statement {
    sid     = "voiceStageS3"
    actions = ["s3:*"]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}/*",
      "${data.aws_s3_bucket.voice-stage.arn}",
    ]
  }
}



# prod
resource "aws_iam_role" "voice-prod" {
  name               = "voice-web-prod"
  path               = "/voice/"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role_prod.json
}

data "aws_iam_policy_document" "allow_assume_role_prod" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:voice-prod:voice-prod"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "voice-prod" {
  name = "voice-web-prod"
  role = aws_iam_role.voice-prod.id

  policy = data.aws_iam_policy_document.voice_prod.json
}

data "aws_iam_policy_document" "voice_prod" {
  statement {
    sid = "voiceProdAllowSSM"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:us-west-2:058419420086:parameter/voice/prod/*"]
  }

  statement {
    sid = "voiceProdAllowKMS"

    actions = ["kms:Decrypt"]

    resources = ["${aws_kms_key.voice-prod.arn}"]
  }

  statement {
    sid = "voiceProdS3"

    actions = ["s3:*"]

    resources = [
      "${data.aws_s3_bucket.voice-prod.arn}/*",
      "${data.aws_s3_bucket.voice-prod.arn}",
    ]
  }
}


# Voice Dataset Bundler
# stage
resource "aws_iam_role" "voice-bundler-stage" {
  name               = "voice-bundler-stage"
  path               = "/voice/"
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role_bundler_stage.json
}

data "aws_iam_policy_document" "allow_assume_role_bundler_stage" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:voice-stage:voice-bundler-stage"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "voice-bundler-stage" {
  name   = "voice-bundler-stage"
  role   = aws_iam_role.voice-bundler-stage.id
  policy = data.aws_iam_policy_document.voice_bundler_stage.json
}

data "aws_iam_policy_document" "voice_bundler_stage" {
  statement {
    sid = "voiceStageBundlerS3"

    actions = ["s3:GetObject"]

    resources = [
      "${data.aws_s3_bucket.voice-stage.arn}/*",
    ]
  }
  statement {
    actions = ["s3:Put*", "s3:GetObject"]

    resources = [
      "arn:aws:s3:::test-corpus/*",
    ]
  }
}
