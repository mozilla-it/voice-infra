data "aws_db_instance" "database" {
  db_instance_identifier = "${var.name}"
}

resource "aws_security_group_rule" "allow_k8s_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${data.aws_db_instance.database.vpc_security_groups.0}"
  source_security_group_id = "${var.client_security_group_id}"
}
