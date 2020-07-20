module "db-prod" {
  source                                 = "github.com/mozilla-it/terraform-modules//aws/database?ref=master"
  type                                   = "mysql"
  name                                   = "voice"
  username                               = "admin"
  identifier                             = "voice-eks-prod"
  instance                               = "db.m5.xlarge"
  storage_gb                             = "100"
  db_version                             = "5.6.46"
  multi_az                               = "false"
  vpc_id                                 = module.vpc.vpc_id
  subnets                                = module.vpc.private_subnets.0
  parameter_group_name                   = aws_db_parameter_group.voice_parameters.name
  backup_retention_period                = 30
  replica_enabled                        = "true"
  instance_replica                       = "db.t3.large"
  replica_db_version                     = "5.6.46"
  performance_insights_enabled           = "true"
  performance_insights_retention         = 7
  replica_performance_insights_retention = 0
  snapshot_identifier                    = "k8s-migration"

  cost_center = "1003"
  project     = "voice"
  environment = "stage"
}

module "db-stage" {
  source                                 = "github.com/mozilla-it/terraform-modules//aws/database?ref=master"
  type                                   = "mysql"
  name                                   = "voice"
  username                               = "admin"
  identifier                             = "voice-eks-stage"
  instance                               = "db.t3.medium"
  storage_gb                             = "50"
  db_version                             = "5.7.28"
  multi_az                               = "false"
  vpc_id                                 = module.vpc.vpc_id
  subnets                                = module.vpc.private_subnets.0
  parameter_group_name                   = aws_db_parameter_group.stage_parameters_57.name
  backup_retention_period                = 3
  replica_enabled                        = "true"
  instance_replica                       = "db.t3.small"
  replica_db_version                     = "5.7.28"
  performance_insights_enabled           = "true"
  performance_insights_retention         = 7
  replica_performance_insights_retention = 0

  cost_center = "1003"
  project     = "voice"
  environment = "stage"
}

module "db-dev" {
  source                         = "github.com/mozilla-it/terraform-modules//aws/database?ref=master"
  type                           = "mysql"
  name                           = "voice"
  username                       = "voice"
  identifier                     = "voice-eks-dev"
  instance                       = "db.t3.small"
  storage_gb                     = "35"
  db_version                     = "5.7.28"
  multi_az                       = "false"
  vpc_id                         = module.vpc.vpc_id
  subnets                        = module.vpc.private_subnets.0
  parameter_group_name           = aws_db_parameter_group.dev_parameters_57.name
  backup_retention_period        = 1
  performance_insights_enabled   = "false"
  performance_insights_retention = 0
  replica_enabled                = "false"
  allow_major_version_upgrade    = "true"

  cost_center = "1003"
  project     = "voice"
  environment = "dev"
}

module "db-sandbox" {
  source                         = "github.com/mozilla-it/terraform-modules//aws/database?ref=master"
  type                           = "mysql"
  name                           = "voice"
  username                       = "voice"
  identifier                     = "voice-eks-sandbox"
  instance                       = "db.t3.small"
  storage_gb                     = "35"
  db_version                     = "5.7.28"
  multi_az                       = "false"
  vpc_id                         = module.vpc.vpc_id
  subnets                        = module.vpc.private_subnets.0
  parameter_group_name           = aws_db_parameter_group.sandbox_parameters_57.name
  backup_retention_period        = 1
  performance_insights_enabled   = "false"
  performance_insights_retention = 0
  replica_enabled                = "false"
  allow_major_version_upgrade    = "true"

  cost_center = "1003"
  project     = "voice"
  environment = "sandbox"
}

module "sentence_collector_stage" {
  source                                 = "github.com/mozilla-it/terraform-modules//aws/database?ref=master"
  type                                   = "mysql"
  name                                   = "sentencecollector"
  username                               = "sentencecollector"
  identifier                             = "sentencecollector"
  instance                               = "db.t3.micro"
  storage_gb                             = "8"
  db_version                             = "8.0.19"
  multi_az                               = "false"
  vpc_id                                 = module.vpc.vpc_id
  subnets                                = module.vpc.private_subnets.0
  parameter_group_name                   = aws_db_parameter_group.sentence_collector.name
  backup_retention_period                = 30
  replica_enabled                        = "false"

  cost_center = "1003"
  project     = "voice"
  environment = "stage"
}

resource "aws_db_parameter_group" "stage_parameters_57" {
  name   = "stage-parameters-57"
  family = "mysql5.7"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "binlog_format"
    value        = "row"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_read_io_threads"
    value        = "32"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_parameter_group" "sandbox_parameters_57" {
  name   = "sandbox-parameters-57"
  family = "mysql5.7"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "binlog_format"
    value        = "row"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = "1"
    apply_method = "immediate"
  }
}

resource "aws_db_parameter_group" "dev_parameters_57" {
  name   = "dev-parameters-57"
  family = "mysql5.7"

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "binlog_format"
    value        = "row"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = "1"
    apply_method = "immediate"
  }
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
    value        = "row"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "long_query_time"
    value        = "1"
    apply_method = "immediate"
  }
}

resource "aws_db_parameter_group" "sentence_collector" {
  name   = "sentence-collector-params"
  family = "mysql8.0"
}
