
data "aws_availability_zones" "data_az" {
  
}

#-------------- VPC --------------#
resource "aws_vpc" "mw_vpc" {
  cidr_block = "192.168.0.0/16"
  
  tags{
      Name = "mediawiki"
  }
}

#-------------- Internet Gateway --------------#
resource "aws_internet_gateway" "mw_igw" {
  vpc_id =" ${aws_vpc.mw_vpc.id}"
  
  tags{
      Name = "mediawiki"
    }
}

#-------------- Route Tables --------------#
resource "aws_route_table" "mw_rt_public" {
  vpc_id = "${aws_vpc.mw_vpc.id}"
  route{
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.mw_igw.id}"
  }

  tags{
      Name = "mediawiki"
  }
}

resource "aws_route_table" "mw_rt_private" {
  vpc_id = "${aws_vpc.mw_vpc.id}"

  tags{
      Name = "mediawiki"
  }
}

#-------------- Subnets --------------#
resource "aws_subnet" "mw_sub_public_a" {
  vpc_id = "${aws_vpc.mw_vpc.id}"
  availability_zone = "${data.aws_availability_zones.data_az.names[0]}"
  cidr_block = "192.168.0.0/24"
  
  tags{
      Name = "mediawiki"
  }
}

resource "aws_subnet" "mw_sub_public_b" {
  vpc_id = "${aws_vpc.mw_vpc.id}"
  availability_zone = "${data.aws_availability_zones.data_az.names[1]}"
  cidr_block = "192.168.1.0/24"
  
  tags{
      Name = "mediawiki"
  }
}

resource "aws_subnet" "mw_sub_private_a" {
  vpc_id = "${aws_vpc.mw_vpc.id}"
  availability_zone = "${data.aws_availability_zones.data_az.names[0]}"
  cidr_block = "192.168.2.0/24"
  
  tags{
      Name = "mediawiki"
  }
}

resource "aws_subnet" "mw_sub_private_b" {
  vpc_id = "${aws_vpc.mw_vpc.id}"
  availability_zone = "${data.aws_availability_zones.data_az.names[1]}"
  cidr_block = "192.168.3.0/24"
  
  tags{
      Name = "mediawiki"
  }
}

#-------------- Route Subnet Association --------------#
resource "aws_route_table_association" "mw_rta_public_a" {
  route_table_id = "${aws_route_table.mw_rt_public.id}"
  subnet_id = "${aws_subnet.mw_sub_public_a.id}"
}

resource "aws_route_table_association" "mw_rta_public_b" {
  route_table_id = "${aws_route_table.mw_rt_public.id}"
  subnet_id = "${aws_subnet.mw_sub_public_b.id}"
}

resource "aws_route_table_association" "mw_rta_private_a" {
  route_table_id = "${aws_route_table.mw_rt_private.id}"
  subnet_id = "${aws_subnet.mw_sub_private_a.id}"
}

resource "aws_route_table_association" "mw_rta_private_b" {
  route_table_id = "${aws_route_table.mw_rt_private.id}"
  subnet_id = "${aws_subnet.mw_sub_private_b.id}"
}

#-------------- Security Groups --------------#

resource "aws_security_group" "mw_sg_public" {
  name = "default_access"
  description = "default access to instances over 80 and 22"
  vpc_id = "${aws_vpc.mw_vpc.id}"

  #ssh
  ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  #http
  ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mw_sg_private" {
  name = "default_access"
  description = "default access to instances over 80, 22 and 3306"
  vpc_id = "${aws_vpc.mw_vpc.id}"

  #ssh
  ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  #mysql
  ingress{
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}






