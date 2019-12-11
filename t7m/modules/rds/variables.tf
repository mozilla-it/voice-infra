variable "name" {}
variable "client_security_group_id" {}

variable "create" {
  default = false
}

variable "vpc_id" {
  default = ""
}

variable "subnet_ids" {
  default = []
}
