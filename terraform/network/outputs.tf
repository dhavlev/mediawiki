output "mw_vpc" {
  value = "${aws_vpc.mw_vpc.id}"
}

output "web_security_group" {
  value = "${aws_security_group.mw_sg_public.id}"
}

output "db_security_group" {
  value = "${aws_security_group.mw_sg_private.id}"
}

output "web_subnet_a" {
  value = "${aws_subnet.mw_sub_public_a.id}"
}

output "web_subnet_b" {
  value = "${aws_subnet.mw_sub_public_b.id}"
}

output "db_subnet" {
  value = "${aws_subnet.mw_sub_private_a.id}"
}