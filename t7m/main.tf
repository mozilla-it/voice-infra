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
  ]

  cluster_tags = {
    Region    = "${var.region}"
    Terraform = "true"
  }
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
  map_roles_count    = "3"
  tags               = "${local.cluster_tags}"
}

data "template_file" "additional_userdata" {
  template = "${file("${path.module}/templates/userdata/additional-userdata.sh")}"
}
