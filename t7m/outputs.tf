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

output "alberto_encrypted_secret_key" {
  value       = "${aws_iam_access_key.alberto.encrypted_secret}"
  description = "Alberto's AWS secret key"
}

output "alberto_access_key" {
  value       = "${aws_iam_access_key.alberto.id}"
  description = "Alberto's AWS access key"
}
