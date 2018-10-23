
locals {
  common_tags = {
    Owner       = "${var.owner}"
    Purpose     = "${var.purpose}"
    Environment = "${var.environment}"
  }

  name_prefix = "${var.owner}-${var.environment}"
}
resource "aws_security_group" "lb_public_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/16"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
}

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-lb-public-sg"
      )
    )}"
}

resource "aws_security_group" "public_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.lb_public_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.anywhere_cidr}"]
  }

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-public-sg"
      )
    )}"
}

resource "aws_security_group" "lb_private_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    security_groups = ["${aws_security_group.public_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-lb-internal-sg"
      )
    )}"
}

resource "aws_security_group" "private_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb_private_sg.id}"]
  }
  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-rds-sg"
      )
    )}"
}
