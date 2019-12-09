resource "kubernetes_config_map" "voice-prod" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-prod"
  }

  data = {
    api.host = "myhost:443"
    db.host  = "dbhost:5432"
  }
}

resource "kubernetes_config_map" "voice-stage" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-stage"
  }

  data = {
    mysql_host      = "${data.aws_db_instance.voice-stage.address}"
    mysql_username  = "read-only"
    mysql_dbname    = "voice"
    aws_region      = "${var.region}"
    bucket_location = "${data.aws_s3_bucket.voice-stage.region}"
  }
}

resource "kubernetes_config_map" "voice-dev" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-dev"
  }

  data = {
    api.host = "myhost:443"
    db.host  = "dbhost:5432"
  }
}

resource "kubernetes_config_map" "voice-sandbox" {
  metadata {
    name      = "voice-configmap"
    namespace = "voice-sandbox"
  }

  data = {
    api.host = "myhost:443"
    db.host  = "dbhost:5432"
  }
}
