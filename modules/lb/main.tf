locals {
  common_tags = {
    Owner       = "${var.owner}"
    Purpose     = "${var.purpose}"
    Environment = "${var.environment}"
  }

  name_prefix = "${var.owner}-${var.environment}"
}

resource "aws_lb" "public_lb" {
  name            = "${local.name_prefix}-lb-public"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.public_lb_security_group_id}"]
  internal        = false

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-public-lb"
      )
    )}"
}

resource "aws_lb_target_group" "public_tg" {
  name     = "${local.name_prefix}-tg-public"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-public-tg"
      )
    )}"
}

resource "aws_lb_listener" "public_lbl" {
  load_balancer_arn = "${aws_lb.public_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.public_tg.arn}"
    type             = "forward"
  }
}
resource "aws_key_pair" "rsa" {
  key_name   = "rsa"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_launch_configuration" "public_lc" {
  name            = "${local.name_prefix}-lc-public"
  image_id        = "${var.aws_amis}"
  instance_type   = "${var.public_instance_type}"
  security_groups = ["${var.public_security_group_id}"]
  key_name = "${aws_key_pair.rsa.key_name}"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "public_asg" {
  vpc_zone_identifier  = ["${var.public_subnet_ids}"]
  name                 = "${local.name_prefix}-asg-public"
  max_size             = "2"
  min_size             = "2"
  desired_capacity     = "2"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.public_lc.name}"
  target_group_arns    = ["${aws_lb_target_group.public_tg.arn}"]
  

  tags = [
    {
      key                 = "Owner"
      value               = "${var.owner}"
      propagate_at_launch = true
    },
    {
      key                 = "Purpose"
      value               = "${var.purpose}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${local.name_prefix}-public"
      propagate_at_launch = true
    },
  ]
}
