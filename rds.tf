data "aws_db_instance" "voice-prod" {
  db_instance_identifier = "voice-prod"
}

data "aws_db_instance" "voice-stage" {
  db_instance_identifier = "voice-stage"
}

resource "aws_security_group_rule" "allow_k8s_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${data.aws_db_instance.voice-stage.vpc_security_groups.0}"
  source_security_group_id = "${module.k8s.worker_security_group_id}"
}
