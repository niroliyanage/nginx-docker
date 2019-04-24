variable access_key {}
variable secret_key {}

provider "aws" {
  profile    = "terraform-network"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "ap-southeast-2"
}

locals {
  main_vpc_id      = "vpc-0bb7d5c53ad168d90"
  public_subnet_id = "subnet-0521826166c907886"
}

resource "aws_security_group" "app_security_group" {
  name        = "app-security-group"
  description = "app security group"
  vpc_id      = "${local.main_vpc_id}"
}

resource "aws_security_group_rule" "app_ssh_ingress" {
  security_group_id = "${aws_security_group.app_security_group.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_alb_http_ingress" {
  security_group_id = "${aws_security_group.app_security_group.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "docker_deamon" {
  security_group_id = "${aws_security_group.app_security_group.id}"
  type              = "ingress"
  from_port         = 2375
  to_port           = 2375
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_egress" {
  security_group_id = "${aws_security_group.app_security_group.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

## Userdata ##

data "template_file" "app_userdata" {
  template = <<END
#!/bin/bash


yum install epel-release -y

yum install nginx docker -y
systemctl enable docker

cat << EOF | tee /etc/docker/daemon.json
{
"hosts": ["tcp://0.0.0.0:2375"," unix:///var/run/docker.sock"]
}
EOF


systemctl start docker


END
}

data "template_cloudinit_config" "app_userdata" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.app_userdata.rendered}"
  }
}

#######

resource "aws_instance" "nginx-docker" {
  ami           = "ami-08bd00d7713a39e7d"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    "${aws_security_group.app_security_group.id}",
  ]

  key_name  = "niro_nginx"
  user_data = "${data.template_cloudinit_config.app_userdata.rendered}"
  subnet_id = "${local.public_subnet_id}"

  tags {
    Name = "${terraform.workspace}-Nginx-App"
  }
}

output "nginx-docker-host" {
  value = "${aws_instance.nginx-docker.public_ip}"
}
