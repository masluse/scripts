data "aws_ami" "default" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = [var.architecture]
  }
  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

resource "aws_security_group" "default" {
  name        = var.name
  description = "Allow all inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "tag:Name"
    values = [var.subnet]
  }
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
}

resource "aws_instance" "default" {
  ami = data.aws_ami.default.id
  instance_type = var.instance_type
  associate_public_ip_address = var.public_ip
  subnet_id = data.aws_subnets.default.ids[0]
  security_groups = [aws_security_group.default.id]
  key_name = "rsa"
  user_data = "${file("${var.user_data}")}"
  tags = {
    Name = var.name
  }
}