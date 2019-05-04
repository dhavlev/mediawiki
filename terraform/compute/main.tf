provider "aws" {
  region = "us-east-1"
  profile = "mediawiki"
}

data "aws_availability_zones" "data_az" {
  
}

#-------------- Key-Pair --------------#
resource "aws_key_pair" "mw_key_pair" {
  key_name = "media_wiki"
  public_key = "${file("/home/user/.ssh/media_wiki.pub")}"
}

resource "aws_instance" "mw_instance_web_a" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.web_security_group}"]
  subnet_id = "${var.web_subnet_a}"

  tags{
    Name = "mw_instance_web_a"
    Project = "mediawiki"
  }
}

resource "aws_instance" "mw_instance_web_b" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.web_security_group}"]
  subnet_id = "${var.web_subnet_b}"

  tags{
    Name = "mw_instance_web_b"
    Project = "mediawiki"
  }
}

resource "aws_instance" "mw_instance_db" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.db_security_group}"]
  subnet_id = "${var.db_subnet}"

  tags{
    Name = "mw_instance_db"
    Project = "mediawiki"
  }
}