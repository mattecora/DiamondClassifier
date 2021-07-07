# diamonds_data_producer_ip_address
# The public IP address of the provisioned data producer instance.

output "diamonds_data_producer_ip_address" {
    value = aws_instance.diamonds_data_producer.public_ip
}