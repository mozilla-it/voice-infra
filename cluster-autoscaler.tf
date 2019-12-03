resource "aws_iam_role" "cluster_autoscaler" {
  name               = "cluster-autoscaler"
  assume_role_policy = "${data.aws_iam_policy_document.cluster_autoscaler_role.json}"
}

data "aws_iam_policy_document" "cluster_autoscaler_role" {
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

resource "aws_iam_role_policy" "cluster_autoscaler" {
  name = "cluster_autoscaler-role-policy"
  role = "${aws_iam_role.cluster_autoscaler.id}"

  policy = "${data.aws_iam_policy_document.cluster_autoscaler_policy.json}"
}

data "aws_iam_policy_document" "cluster_autoscaler_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = [
      "*",
    ]
  }
}
