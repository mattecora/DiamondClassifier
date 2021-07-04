resource "aws_key_pair" "diamonds_data_producer_ssh_key" {
    key_name   = "diamonds-data-producer-ssh-key"
    public_key = file("${path.module}/aws_project_ssh_key.pub")
}

resource "aws_security_group" "diamonds_data_producer_security_group" {
    name    = "diamonds-data-producer-security-group"
    ingress = [
        {
            cidr_blocks      = [ "0.0.0.0/0" ]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        }
    ]
}

resource "aws_instance" "diamonds_data_producer" {
    ami                    = "ami-0f89681a05a3a9de7"
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.diamonds_data_producer_ssh_key.key_name
    vpc_security_group_ids = [ aws_security_group.diamonds_data_producer_security_group.id ]

    tags = {
        Name = "diamonds-data-producer"
    }
}