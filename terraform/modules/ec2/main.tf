# diamonds_data_producer_user_data
# The cloud-init configuration for the data producer instance.

data "cloudinit_config" "diamonds_data_producer_user_data" {
    gzip = false
    base64_encode = false

    part {
        content_type = "text/cloud-config"
        content      = yamlencode({
            repo_update   = true
            repo_upgrade  = "all"

            write_files   = [
                {
                    path     = "/etc/producer/produce.py"
                    encoding = "b64"
                    content  = filebase64("${path.module}/../../../producer/produce.py")
                },
                {
                    path     = "/etc/systemd/system/producer.service"
                    encoding = "b64"
                    content  = filebase64("${path.module}/../../../producer/producer.service")
                }
            ]

            runcmd = [
                "yes | pip3 install pandas boto3",
                "systemctl enable producer",
                "systemctl start producer"
            ]
        })
    }
}

# diamonds_data_producer_ssh_key
# The RSA key pair for the data producer instance.

resource "aws_key_pair" "diamonds_data_producer_ssh_key" {
    key_name   = "diamonds-data-producer-ssh-key"
    public_key = file("${path.module}/../../../producer/diamonds_data_producer_ssh_key.pub")
}

# diamonds_data_producer_security_group
# The security group for the data producer instance.

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

# diamonds_data_producer
# The data producer EC2 instance.

resource "aws_instance" "diamonds_data_producer" {
    ami                    = "ami-0f89681a05a3a9de7"
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.diamonds_data_producer_ssh_key.key_name
    vpc_security_group_ids = [ aws_security_group.diamonds_data_producer_security_group.id ]
    iam_instance_profile   = var.diamonds_data_producer_profile_name
    user_data              = data.cloudinit_config.diamonds_data_producer_user_data.rendered

    tags = {
        Name = "diamonds-data-producer"
    }
}