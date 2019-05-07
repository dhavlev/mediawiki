provider "aws" {
  region = "us-east-1"
  profile = "mediawiki"
}

data "aws_availability_zones" "data_az" {
  
}

#-------------- Key-Pair --------------#
resource "aws_key_pair" "mw_key_pair" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


#-------------- AWS Instances --------------#
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

#-------------- ELB --------------#
resource "aws_elb" "mw_elb" {

  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > ../aws_hosts 

[dev-mediawiki-web]
dev-mediawiki-web-1 ansible_host=${aws_instance.mw_instance_web_a.public_ip}
dev-mediawiki-web-2 ansible_host=${aws_instance.mw_instance_web_b.public_ip}

[dev-mediawiki-web:vars]
lb_url=${aws_elb.mw_elb.dns_name}
database_ip=${aws_instance.mw_instance_db.private_ip}

[dev-mediawiki-sql]
dev-mediawiki-sql-1 ansible_host=${aws_instance.mw_instance_db.private_ip}

[dev-mediawiki-sql:vars]
web1=${aws_instance.mw_instance_web_a.private_ip}
web2=${aws_instance.mw_instance_web_b.private_ip}

[mysql-servers:children]
dev-mediawiki-sql

[apache-servers:children]
dev-mediawiki-web
EOF
EOD
  }
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.mw_instance_web_a.id} ${aws_instance.mw_instance_web_b.id} ${aws_instance.mw_instance_db.id} --profile ${var.aws_profile} && cd .. && ansible-playbook -i aws_hosts master-install-mediawiki.yaml"
  }
  name = "media-wiki-elb"
  subnets = ["${var.web_subnet_a}", "${var.web_subnet_b}"]
  instances = ["${aws_instance.mw_instance_web_a.id}", "${aws_instance.mw_instance_web_b.id}"]
  security_groups = ["${var.web_security_group}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    timeout             = "3"
    target              = "TCP:80"
    interval            = "30"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "mw_elb"
    Project = "mediawiki"
  }
}

resource "aws_lb_cookie_stickiness_policy" "mw_lb_policy" {
  name                     = "mw-lb-policy"
  load_balancer            = "${aws_elb.mw_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}
