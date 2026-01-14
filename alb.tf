# An existing VPC and subnets are required
# Example assumes you have 'aws_vpc.main' and 'aws_subnet.public' resources defined elsewhere

# Security Group for the ALB
resource "aws_security_group" "lb-sg" {
  name        = "lb_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id # Assumes a VPC resource named aws_vpc.main

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Target Group to route traffic to
resource "aws_lb_target_group" "tg" {
  name     = "tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# The Application Load Balancer resource
resource "aws_lb" "test-alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  # Assumes public subnets named aws_subnet.public are available
  # subnets          = [for subnet in aws_subnet.public : subnet.id]
  subnets = [ aws_subnet.pub_sub1.id,aws_subnet.pub_sub2.id]
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

# Listener to forward traffic to the Target Group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-tg.arn
  }
}
