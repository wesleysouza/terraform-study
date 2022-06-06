output "ip_address" {
  value = aws_instance.ansible-lab.public_ip
}

output "dns_name" {
  value = aws_instance.ansible-lab.public_dns
}