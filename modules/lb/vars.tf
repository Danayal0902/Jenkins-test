variable "environment" {}
variable "owner" {}
variable "purpose" {}
variable "vpc_id" {}
variable "public_instance_type" {}
variable "public_security_group_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "public_key_path" {}

variable "aws_amis" {}

variable "public_lb_security_group_id" {}
