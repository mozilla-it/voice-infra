module "role_kubernetes_external_secrets" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v3.7.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-kubernetes-external-secrets"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.kubernetes_external_secrets.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:kubernetes-external-secrets"]
}

resource "aws_iam_policy" "kubernetes_external_secrets" {
  name_prefix = "${local.cluster_name}-kubernetes-external-secrets"
  path        = "/"
  description = "Kubernetes-external-secrets policy for ${local.cluster_name}"
  policy      = data.aws_iam_policy_document.kubernetes_external_secrets.json
}

data "aws_iam_policy_document" "kubernetes_external_secrets" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "arn:aws:secretsmanager:us-west-2:${data.aws_caller_identity.current.account_id}:secret:/commonvoice/*",
      "arn:aws:secretsmanager:us-west-2:${data.aws_caller_identity.current.account_id}:secret:/sentence-collector/*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      data.aws_kms_alias.ssm.target_key_arn
    ]
  }
}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}
