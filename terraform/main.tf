provider "aws" {
  region = "us-east-1"
  profile = "mediawiki"
}

module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
  ami = "ami-036ede09922dadc9b"
  key_name = "media_wiki"
  public_key_path = "/home/cloud_user/.ssh/media_wiki.pub"

  web_instance_type = "t2.micro"
  web_security_group = "${aws_security_group.mw_sg_public.id}"

  db_instance_type = "t2.micro"
  db_security_group = "${aws_security_group.mw_sg_private.id}"

  web_subnet_a = "${aws_subnet.mw_sub_public_a.id}"
  web_subnet_b = "${aws_subnet.mw_sub_public_b.id}"
  db_subnet = "${aws_subnet.mw_sub_private_a.id}"
}