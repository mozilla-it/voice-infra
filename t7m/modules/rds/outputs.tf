output "address" {
  value = "${element(compact(concat(data.aws_db_instance.database.*.address, aws_db_instance.database.*.address)), 0)}"
}

output "username" {
  value = "${var.create ? "voice" : "read-only"}"
}

output "password" {
  value = "${var.create ? element(concat(random_string.password.*.result, list("")),0) : "read-only"}"
}
