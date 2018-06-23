provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web-server" {
  ami = "${var.ami}"

  count = 3

  instance_type = "${var.instance}"

    user_data = <<-EOF
              #!/bin/bash
              cd /home/ec2-user
              touch "INSTANCE-${count.index}"
              sudo pip install http
              nohup python -m SimpleHTTPServer "${var.port}" &
              EOF

  tags {
    Name = "web-server-${count.index}"
   }

   vpc_security_group_ids = ["${aws_security_group.sec-group.id}"]
}

resource "aws_security_group" "sec-group" {
  name = "my-sec-group"

  ingress {
    from_port = "${var.port}"
    to_port = "${var.port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-group" {
  name = "elb-group"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}

data "aws_subnet_ids" "all-nets" {
  vpc_id = "${aws_default_vpc.default.id}"
}

resource "aws_alb" "alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb-group.id}"]
  subnets            = ["${data.aws_subnet_ids.all-nets.ids}"]
}

resource "aws_lb_target_group" "tg" {
  name     = "tf-example-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default.id}"
}

resource "aws_lb_target_group_attachment" "test" {
  count = 3
  target_group_arn = "${aws_lb_target_group.tg.arn}"
  target_id = "${element(aws_instance.web-server.*.id, count.index)}"
  port = "${var.port}"
}

resource "aws_lb_listener" "my-listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.tg.arn}"
    type             = "forward"
  }
}