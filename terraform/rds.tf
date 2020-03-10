module "db-dev" {
  # TODO change to upstream once PR #18 is merged
  source                  = "github.com/mozilla-it/terraform-modules//aws/database?ref=6fc2eb44d50d6da4f854ea9954c317537e7c7504"
  type                    = "mysql"
  name                    = "voice"
  username                = "voice"
  identifier              = "voice-eks-dev"
  storage_gb              = "35"
  db_version              = "5.6"
  multi_az                = "false"
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets.0
  parameter_group_name    = aws_db_parameter_group.voice_parameters.name
  backup_retention_period = 1
  replica_enabled         = "true"

  cost_center = "1003"
  project     = "voice"
  environment = "dev"
}

module "db-sandbox" {
  # TODO change to upstream once PR #18 is merged
  source                  = "github.com/mozilla-it/terraform-modules//aws/database?ref=6fc2eb44d50d6da4f854ea9954c317537e7c7504"
  type                    = "mysql"
  name                    = "voice"
  username                = "voice"
  identifier              = "voice-eks-sandbox"
  storage_gb              = "35"
  db_version              = "5.6"
  multi_az                = "false"
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets.0
  parameter_group_name    = aws_db_parameter_group.voice_parameters.name
  backup_retention_period = 1
  replica_enabled         = "true"

  cost_center = "1003"
  project     = "voice"
  environment = "sandbox"
}

resource "aws_db_parameter_group" "voice_parameters" {
  name   = "voice-db-parameters"
  family = "mysql5.6"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "immediate"
  }
}
