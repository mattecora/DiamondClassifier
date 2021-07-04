output "diamonds_data_producer_ip_address" {
    value = aws_instance.diamonds_data_producer.public_ip
}

output "diamonds_data_producer_dns_name" {
    value = aws_instance.diamonds_data_producer.public_dns
}