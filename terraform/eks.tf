locals {
  cluster_name    = "voice-prod"
  cluster_version = "1.16"

  cluster_tags = {
    Region    = var.region
    Terraform = "true"
  }

  roles = [
    {
      username = "system:node:{{EC2PrivateDNSName}}"
      rolearn  = "arn:aws:iam::058419420086:role/voice-prod20200214152738997200000005"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      username = "itsre-admin"
      rolearn  = "arn:aws:iam::178589013767:role/itsre-admin"
      groups   = ["system:masters"]
    },
    {
      username = "AdminRole"
      # This is a bug in k8s, the role in IAM will not match this
      # file since k8s has issues parsing roles with paths
      rolearn = "arn:aws:iam::178589013767:role/AdminRole"
      groups  = ["system:masters"]
    },
    {
      username = "maws-admin"
      rolearn  = "arn:aws:iam::058419420086:role/maws-admin"
      groups   = ["system:masters"]
    },
    {
      username = "voice-developers"
      rolearn  = "arn:aws:iam::058419420086:role/developers"
      groups   = ["voice-developers"]
    },
    {
      username = "voice-developers"
      rolearn  = "arn:aws:iam::058419420086:role/maws-devs-rw"
      groups   = ["system:masters"]
    },
  ]
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = local.cluster_name
  node_group_name = "${local.cluster_name}_worker"
  node_role_arn   = module.eks.worker_iam_role_arn
  subnet_ids      = module.vpc.private_subnets.0
  instance_types  = ["m5.large"]

  scaling_config {
    desired_size = 9
    max_size     = 15
    min_size     = 3
  }

  labels = {
    node            = "managed"
    node_group_name = "${local.cluster_name}_worker"
  }
  tags = {
    Name = "voice-prod-eks-node"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "~> 8.2.0"
  cluster_name     = local.cluster_name
  cluster_version  = local.cluster_version
  vpc_id           = module.vpc.vpc_id
  subnets          = module.vpc.private_subnets.0
  map_roles        = local.roles
  kubeconfig_name  = local.cluster_name
  write_kubeconfig = "false"
  manage_aws_auth  = "true"
  enable_irsa      = "true"
  tags = {
    Name      = local.cluster_name
    Terraform = "true"
  }
}

data "aws_eks_cluster" "voice-prod" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "voice-prod" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.voice-prod.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.voice-prod.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.voice-prod.token
  load_config_file       = false
  version                = "~> 1.11" # This is the version of the provider, not the target k8s cluster.
}
