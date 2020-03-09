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
