module "db-prod" {
  source                   = "modules/rds"
  name                     = "voice-prod"
  client_security_group_id = "${module.k8s.worker_security_group_id}"
}

module "db-stage" {
  source                   = "modules/rds"
  name                     = "voice-stage"
  client_security_group_id = "${module.k8s.worker_security_group_id}"
}

module "db-dev" {
  source                   = "modules/rds"
  create                   = true
  name                     = "voice-dev"
  client_security_group_id = "${module.k8s.worker_security_group_id}"
  vpc_id                   = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids               = "${split(",", data.terraform_remote_state.vpc.private_subnets)}"
}

module "db-sandbox" {
  source                   = "modules/rds"
  create                   = true
  name                     = "voice-sandbox"
  client_security_group_id = "${module.k8s.worker_security_group_id}"
  vpc_id                   = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids               = "${split(",", data.terraform_remote_state.vpc.private_subnets)}"
}
