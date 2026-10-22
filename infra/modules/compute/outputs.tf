output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "first_instance_ip" {
  value = aws_instance.app_first.private_ip
}
