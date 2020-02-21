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

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:us-west-2:058419420086:parameter/voice/dev/*"
      },
	    {
      "Effect": "Allow",
      "Action": [
				"kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.voice-dev.arn}"
      }
  ]
}
EOF
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

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:us-west-2:058419420086:parameter/voice/sandbox/*"
      },
	    {
      "Effect": "Allow",
      "Action": [
				"kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.voice-sandbox.arn}"
      }
  ]
}
EOF
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
  name = "voice-web-stage"
  role = aws_iam_role.voice-stage.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:us-west-2:058419420086:parameter/voice/stage/*"
      },
	    {
      "Effect": "Allow",
      "Action": [
				"kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.voice-stage.arn}"
      }
  ]
}
EOF
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

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:us-west-2:058419420086:parameter/voice/prod/*"
      },
	    {
      "Effect": "Allow",
      "Action": [
				"kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.voice-prod.arn}"
      }
  ]
}
EOF
}
