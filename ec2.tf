data "aws_ami" "rhel_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9.*x86_64*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # Canonical
}

resource "aws_instance" "test" {
  ami             = data.aws_ami.rhel_image.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.pub_sub1.id
  key_name        = var.key_pair
  security_groups = [aws_security_group.main_sg.id]
  user_data       = base64encode("#!/bin/bash\\necho 'Hello, World!' > index.html\\nnohup busybox httpd -f -p 80 &") # Example user data to run a simple web server


  tags = {
    Name = "test-server"
  }
}

resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}



