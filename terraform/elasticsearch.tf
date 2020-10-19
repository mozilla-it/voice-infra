module "elasticsearch-prod" {
  source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch"
  domain_name             = "voice-eks-prod"
  subnet_ids              = [element(module.vpc.private_subnets[0], 0)]
  vpc_id                  = module.vpc.vpc_id
  ingress_security_groups = "sg-0b42a7cfbb3ccb3bc"
  ebs_volume_size         = 200
  es_instance_type        = "m3.large.elasticsearch"
  es_instance_count       = 3
}
