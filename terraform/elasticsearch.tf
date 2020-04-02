module "elasticsearch-stage" {
	source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch?ref=f59a68b3cd14c441c5c386bdb0023c3dbd8ab120"
	domain_name             = "voice-eks-stage"
	subnet_ids              = [element(module.vpc.private_subnets[0], 0)]
	vpc_id                  = module.vpc.vpc_id
	ingress_security_groups = "sg-0b42a7cfbb3ccb3bc"
	ebs_volume_size         = 35
}

module "elasticsearch-sandbox" {
	source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch?ref=f59a68b3cd14c441c5c386bdb0023c3dbd8ab120"
	domain_name             = "voice-eks-sandbox"
	subnet_ids              = [element(module.vpc.private_subnets[0], 0)]
	vpc_id                  = module.vpc.vpc_id
	ingress_security_groups = "sg-0b42a7cfbb3ccb3bc"
	ebs_volume_size         = 10
	tags                    = var.common-tags
}
