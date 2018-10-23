
locals {
  common_tags = {
    Owner       = "${var.owner}"
    Purpose     = "${var.purpose}"
    Environment = "${var.environment}"
  }

  name_prefix = "${var.owner}-${var.environment}"
}

resource "aws_db_instance" "default-db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "${var.db_name}"
  username             = "${var.username}"
  password             = "${var.password}"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [ "${var.private_security_group_id}" ]
  db_subnet_group_name   = "${aws_db_subnet_group.rds-private.id}"
  final_snapshot_identifier = "terraform-rds"
  skip_final_snapshot = true
  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-default-db"
      )
    )}"

  }
  resource "aws_db_subnet_group" "rds-private" {
  name        = "rdsmain-private-2"
  description = "Private subnets for RDS instance"
  subnet_ids  =  ["${var.private_subnet_ids}"]
}
