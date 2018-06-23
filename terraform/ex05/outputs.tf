output "server-ip" {
  value = "${aws_instance.web-server.*.public_ip}"
}

output "elb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}