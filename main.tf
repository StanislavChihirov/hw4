terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "credentials.txt"
  profile                 = "customprofile"
}

# Configure the AWS Resource
resource "aws_instance" "ubuntu_with_apache" {
    count         = 1
    ami           = "ami-05f7491af5eef733a"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.ubuntu_with_apache.id ]
    key_name      = aws_key_pair.generated_key.key_name
    user_data     = file("instapache.sh")
    tags = {
    Name = "ubuntu_with_apache"
    }
}

# Configure the AWS Security Group
resource "aws_security_group" "ubuntu_with_apache" {
  name = "ubuntu_with_apache"
  description = "Allow 80, 443, 22 port"
  
  dynamic "ingress" {
      for_each            = ["80", "443", "22"]
      content {
        from_port         = ingress.value
        to_port           = ingress.value
        protocol          = "tcp"
        cidr_blocks       = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks  = [ "::/0" ]
        }
      }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow http/s and ssh"
  }
}

# Configure the AWS SSH-Key
resource "tls_private_key" "awsconnect" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "awsconnect"
  public_key = tls_private_key.awsconnect.public_key_openssh
  
  provisioner "local-exec" { 
    command = "echo '${tls_private_key.awsconnect.private_key_pem}' > ./awsconnect.pem"
  }
}