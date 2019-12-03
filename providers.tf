provider "aws" {
  version = ">= 2.6.0"
  region  = "${var.region}"
}

provider "local" {
  version = "~> 1.2"
}

data "aws_eks_cluster" "k8s" {
  name = "${module.k8s.cluster_id}"
}

data "aws_eks_cluster_auth" "k8s" {
  name = "${module.k8s.cluster_id}"
}

provider "kubernetes" {
  host                   = "${data.aws_eks_cluster.k8s.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.k8s.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.k8s.token}"
  load_config_file       = false
}
