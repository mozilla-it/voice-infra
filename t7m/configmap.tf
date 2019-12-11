resource "kubernetes_config_map" "voice-prod" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-prod"
  }

  data = {
    environment     = "prod"
    mysql_host      = "${module.db-prod.address}"
    mysql_username  = "${module.db-prod.username}"
    mysql_password  = "${module.db-prod.password}"
    mysql_dbname    = "voice"
    aws_region      = "${var.region}"
    bucket_location = "${data.aws_s3_bucket.voice-prod.region}"
    bucket_name     = "${data.aws_s3_bucket.voice-prod.bucket}"
  }
}

resource "kubernetes_config_map" "voice-stage" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-stage"
  }

  data = {
    environment     = "stage"
    mysql_host      = "${module.db-stage.address}"
    mysql_username  = "${module.db-stage.username}"
    mysql_password  = "${module.db-stage.password}"
    mysql_dbname    = "voice"
    aws_region      = "${var.region}"
    bucket_location = "${data.aws_s3_bucket.voice-stage.region}"
    bucket_name     = "${data.aws_s3_bucket.voice-stage.bucket}"
  }
}

resource "kubernetes_config_map" "voice-dev" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-dev"
  }

  data = {
    environment     = "stage"
    mysql_host      = "${module.db-dev.address}"
    mysql_username  = "${module.db-dev.username}"
    mysql_password  = "${module.db-dev.password}"
    mysql_dbname    = "voice"
    aws_region      = "${var.region}"
    bucket_location = "${data.aws_s3_bucket.voice-stage.region}"
    bucket_name     = "${data.aws_s3_bucket.voice-stage.bucket}"
  }
}

resource "kubernetes_config_map" "voice-sandbox" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-sandbox"
  }

  data = {
    environment     = "stage"
    mysql_host      = "${module.db-sandbox.address}"
    mysql_username  = "${module.db-sandbox.username}"
    mysql_password  = "${module.db-sandbox.password}"
    mysql_dbname    = "voice"
    aws_region      = "${var.region}"
    bucket_location = "${data.aws_s3_bucket.voice-stage.region}"
    bucket_name     = "${data.aws_s3_bucket.voice-stage.bucket}"
  }
}
