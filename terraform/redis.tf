module "redis-dev" {
    source                     = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=tags/0.16.0"
    stage                      = "dev"
    name                       = "voice-eks"
    vpc_id                     = module.vpc.vpc_id
		allowed_security_groups    = ["sg-0b42a7cfbb3ccb3bc"]
    subnets                    = module.vpc.private_subnets.0
    cluster_size               = 1
    instance_type              = "cache.t3.micro"
		availability_zones         = ["us-west-2a", "us-west-2b", "us-west-2c"]
    engine_version             = "5.0.0"
    family                     = "redis5.0"
		tags                       = var.common-tags
}

module "redis-sandbox" {
    source                     = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=tags/0.16.0"
    stage                      = "sandbox"
    name                       = "voice-eks"
    vpc_id                     = module.vpc.vpc_id
		allowed_security_groups    = ["sg-0b42a7cfbb3ccb3bc"]
    subnets                    = module.vpc.private_subnets.0
    cluster_size               = 1
    instance_type              = "cache.t3.micro"
		availability_zones         = ["us-west-2a", "us-west-2b", "us-west-2c"]
    engine_version             = "5.0.0"
    family                     = "redis5.0"
		tags                       = var.common-tags
}
