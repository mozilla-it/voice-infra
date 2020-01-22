locals {
  workers = [
    {
      instance_type                 = "m5.large"
      key_name                      = "nubis"
      subnets                       = "${data.terraform_remote_state.vpc.private_subnets}"
      autoscaling_enabled           = true
      asg_desired_capacity          = 5
      asg_min_size                  = 3
      asg_max_size                  = 10
      spot_price                    = "0.08"
      additional_userdata           = "${data.template_file.additional_userdata.rendered}"
      additional_security_group_ids = "${data.terraform_remote_state.vpc.instance_security_groups}"
    },
  ]

  map_roles = [
    {
      username = "itsre-admin"
      role_arn = "arn:aws:iam::178589013767:role/itsre-admin"
      group    = "system:masters"
    },
    {
      username = "AdminRole"

      # This is a bug in k8s, the role in IAM will not match this
      # file since k8s has issues parsing roles with paths
      role_arn = "arn:aws:iam::178589013767:role/AdminRole"

      group = "system:masters"
    },
    {
      username = "jenkins"
      role_arn = "arn:aws:iam::178589013767:role/ci-mdn-us-west-2"
      group    = "jenkins-access"
    },
    {
      username = "developers",
      role_arn = "${aws_iam_role.developers.arn}"
      group    = "developers"
    },
  ]

  cluster_tags = {
    Region    = "${var.region}"
    Terraform = "true"
  }
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
        "${aws_iam_user.rshaw.arn}"
      ]
    }
  }
}

resource "aws_iam_role" "developers" {
  name = "developers"
  assume_role_policy = "${data.aws_iam_policy_document.developers_assume_role.json}"
}

resource "aws_iam_user" "rshaw" {
  name = "rshaw"
  path = "/users/"
}

resource "aws_iam_user_policy" "rshaw" {
  name = "rshaw"
  user = "${aws_iam_user.rshaw.name}"

  policy = "${data.aws_iam_policy_document.rshaw.json}"
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

module "k8s" {
  source = "github.com/mdn/infra//k8s/clusters/eks/modules/eks"

  region      = "${var.region}"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  eks_subnets = "${split(",",data.terraform_remote_state.vpc.public_subnets)}"

  cluster_name    = "voice"
  cluster_version = "1.14"

  worker_groups      = "${local.workers}"
  worker_group_count = "1"
  map_roles          = "${local.map_roles}"
  map_roles_count    = "4"
  tags               = "${local.cluster_tags}"
}

data "template_file" "additional_userdata" {
  template = "${file("${path.module}/templates/userdata/additional-userdata.sh")}"
}
