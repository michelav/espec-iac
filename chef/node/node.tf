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

variable "ukey" {
  type = "string"
  description = "O caminho da chave do usuario"
  default = "user.pem"
}

variable "ssh_private_key" {
  type = "string"
  description = "O caminho da chave ssh"
  default = "ssh.pem"
}

variable "ssh_public_key" {
  type = "string"
  description = "O caminho da chave ssh"
  default = "ssh.pem"
}

resource "aws_instance" "node" {
  ami = "${var.ami}"

  instance_type = "${var.instance}"

  provisioner "chef" {
    # attributes_json = <<-EOF
    #   {
    #     "key": "value",
    #     "app": {
    #       "cluster1": {
    #         "nodes": [
    #           "webserver1",
    #           "webserver2"
    #         ]
    #       }
    #     }
    #   }
    # EOF
    # environment     = "_default"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("${var.ssh_private_key}")}"
    }

    run_list        = ["web_server::default"]
    node_name       = "webserver01"
    # secret_key      = "${file("../encrypted_data_bag_secret")}"
    server_url      = "https://api.chef.io/organizations/uece-iac"
    recreate_client = true
    user_name       = "cursodecloud"
    user_key        = "${file("${var.ukey}")}"
    # version         = "12.4.1"
    # If you have a self signed cert on your chef server change this to :verify_none
    # ssl_verify_mode = ":verify_peer"
  }

  key_name = "iac"

  tags {
    Name = "webserver01"
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
  public_key = "${file("${var.ssh_public_key}")}"
}

output "node-ip" {
  value = "${aws_instance.node.public_ip}"
}