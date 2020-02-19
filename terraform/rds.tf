module "db-dev" {
  # TODO: change to upstream once PR#9 is merged
  source     = "github.com/mozilla-it/terraform-modules//aws/database?ref=53c4a23826a3d8deafda20503316d37aaf7b225f"
  type       = "mysql"
  name       = "voice"
  username   = "voice"
  identifier = "voice-eks-dev"
  storage_gb = "35"
  db_version = "5.6"
  multi_az   = "false"
  vpc_id     = module.vpc.vpc_id
  subnets    = module.vpc.private_subnets.0

  cost_center = "1003"
  project     = "voice"
  environment = "dev"
}

module "db-sandbox" {
	# TODO: change to upstream once PR#9 is merged
  source                   = "github.com/mozilla-it/terraform-modules//aws/database?ref=53c4a23826a3d8deafda20503316d37aaf7b225f"
	type                     = "mysql"
  name                     = "voice"
	username                 = "voice"
	identifier               = "voice-eks-sandbox"
	storage_gb               = "35"
	db_version               = "5.6"
	multi_az                 = "false"
  vpc_id                   = module.vpc.vpc_id
  subnets                  = module.vpc.private_subnets.0
	
	cost_center              = "1003"
	project                  = "voice"
	environment              = "sandbox"
}
