resource "aws_key_pair" "diamonds_data_producer_ssh_key" {
    key_name   = "diamonds-data-producer-ssh-key"
    public_key = file("${path.module}/aws_project_ssh_key.pub")
}

resource "aws_security_group" "diamonds_data_producer_security_group" {
    name  = "diamonds-data-producer-security-group"

    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }
    
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
    }
}

resource "aws_instance" "diamonds_data_producer" {
    ami                    = "ami-0f89681a05a3a9de7"
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.diamonds_data_producer_ssh_key.key_name
    vpc_security_group_ids = [ aws_security_group.diamonds_data_producer_security_group.id ]
    iam_instance_profile   = var.diamonds_data_producer_profile_name

    tags = {
        Name = "diamonds-data-producer"
    }
}