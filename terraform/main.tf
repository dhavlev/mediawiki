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
  web_security_group = "${module.network.web_security_group}"

  db_instance_type = "t2.micro"
  db_security_group = "${module.network.db_security_group}"

  web_subnet_a = "${module.network.web_subnet_a}"
  web_subnet_b = "${module.network.web_subnet_b}"
  db_subnet = "${module.network.db_subnet}"
}