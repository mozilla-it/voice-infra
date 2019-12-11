data "aws_db_instance" "database" {
  count                  = "${var.create ? 0 : 1 }"
  db_instance_identifier = "${var.name}"
}

resource "aws_security_group_rule" "allow_k8s_mysql" {
  count                    = "${var.create ? 0 : 1 }"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${data.aws_db_instance.database.vpc_security_groups.0}"
  source_security_group_id = "${var.client_security_group_id}"
}

resource "random_string" "password" {
  count   = "${var.create ? 1 : 0 }"
  length  = 16
  special = false
}

resource "aws_db_instance" "database" {
  count          = "${var.create ? 1 : 0 }"
  instance_class = "db.t3.medium"
  identifier     = "${var.name}"
  engine         = "mysql"
  name           = "voice"
  username       = "voice"
  password       = "${random_string.password.result}"

  apply_immediately = true

  vpc_security_group_ids = [
    "${aws_security_group.database.*.id}",
  ]

  db_subnet_group_name = "${element(concat(aws_db_subnet_group.database.*.name, list("")), 0)}"

  allocated_storage = "20"
}

resource "aws_security_group" "database" {
  count  = "${var.create ? 1 : 0 }"
  vpc_id = "${var.vpc_id}"
  name   = "${var.name}-rds"

  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"

    security_groups = [
      "${var.client_security_group_id}",
    ]
  }

  ingress {
    self      = true
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "database" {
  count       = "${var.create ? 1 : 0 }"
  name        = "${var.name}-rds-subnet-group"
  description = "${var.name}-rds-subnet-group"

  subnet_ids = [
    "${var.subnet_ids}",
  ]
}
