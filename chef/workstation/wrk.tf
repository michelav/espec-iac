provider "aws" {
  region = "sa-east-1"
  shared_credentials_file = "/home/michel/devel/terraform-aws.cfg"
}

variable "ami" {
  type = "string"
  description = "a AMI que sera utilizada"
  default = "ami-8eecc9e2"
}

variable "instance" {
  type = "string"
  description = "O Tipo de instancia que sera utilizada"
  default = "t2.micro"
}

resource "aws_instance" "workstation" {
  ami = "${var.ami}"

  instance_type = "${var.instance}"

    user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y curl vim
              curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 3.1.0
              chef -v
              EOF

  key_name = "iac"

  tags {
    Name = "workstation"
   }

   vpc_security_group_ids = ["${aws_security_group.wrk-sec-group.id}"]
}


resource "aws_security_group" "wrk-sec-group" {
  name = "wrk-sec-group"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "iac"
  public_key = "${file("~/devel/keys/terraform.key.pub")}"
}

output "workstation-ip" {
  value = "${aws_instance.workstation.public_ip}"
}