output "public_lb_security_group_id" {
  value = "${aws_security_group.lb_public_sg.id}"
}

output "private_lb_security_group_id" {
  value = "${aws_security_group.lb_private_sg.id}"
}

output "public_security_group_id" {
  value = "${aws_security_group.public_sg.id}"
}

output "private_security_group_id" {
  value = "${aws_security_group.private_sg.id}"
}
