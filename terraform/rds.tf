module "db-stage" {
  source                  = "github.com/mozilla-it/terraform-modules//aws/database"
  type                    = "mysql"
  name                    = "voice"
  username                = "admin"
  identifier              = "voice-eks-stage"
  instance                = "db.t3.small"
  storage_gb              = "32"
  db_version              = "5.6"
  multi_az                = "false"
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets.0
  parameter_group_name    = aws_db_parameter_group.voice_parameters.name
  backup_retention_period = 3
  replica_enabled         = "true"

  cost_center = "1003"
  project     = "voice"
  environment = "stage"
}

module "db-dev" {
  source                  = "github.com/mozilla-it/terraform-modules//aws/database"
  type                    = "mysql"
  name                    = "voice"
  username                = "voice"
  identifier              = "voice-eks-dev"
  instance                = "db.t3.small"
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
  source                  = "github.com/mozilla-it/terraform-modules//aws/database"
  type                    = "mysql"
  name                    = "voice"
  username                = "voice"
  identifier              = "voice-eks-sandbox"
  instance                = "db.t3.small"
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
