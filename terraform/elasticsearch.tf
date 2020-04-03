module "elasticsearch-stage" {
	source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch"
	domain_name             = "voice-eks-stage"
	subnet_ids              = [element(module.vpc.private_subnets[0], 0)]
	vpc_id                  = module.vpc.vpc_id
	ingress_security_groups = "sg-0b42a7cfbb3ccb3bc"
	ebs_volume_size         = 80
	es_instance_type        = "m3.medium.elasticsearch"
}

module "elasticsearch-prod" {
	source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch"
	domain_name             = "voice-eks-prod"
	subnet_ids              = [element(module.vpc.private_subnets[0], 0)]
	vpc_id                  = module.vpc.vpc_id
	ingress_security_groups = "sg-0b42a7cfbb3ccb3bc"
	ebs_volume_size         = 80
	es_instance_type        = "m3.medium.elasticsearch"
}
