provider "aws" {
  region = "us-east-1"
  profile = "mediawiki"
}

module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
  ami = "${var.ami}"
  key_name = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  aws_profile = "${var.aws_profile}"

  web_instance_type = "${var.web_instance_type}"
  web_security_group = "${module.network.web_security_group}"

  db_instance_type = "${var.db_instance_type}"
  db_security_group = "${module.network.db_security_group}"

  web_subnet_a = "${module.network.web_subnet_a}"
  web_subnet_b = "${module.network.web_subnet_b}"
  db_subnet = "${module.network.db_subnet}"
}