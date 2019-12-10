output "cluster_name" {
  value = "${module.k8s.cluster_id}"
}

output "worker_iam_role_arn" {
  value = "${module.k8s.worker_iam_role_arn}"
}

output "worker_security_group_id" {
  value = "${module.k8s.worker_security_group_id}"
}

output "velero_bucket" {
  value       = "${aws_s3_bucket.velero.id}"
  description = "Bucket for Velero to store backups too"
}
