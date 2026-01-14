resource "aws_ami_from_instance" "test-ami" {
  name               = "test_ami"
  source_instance_id = aws_instance.test.id
  depends_on = [ aws_instance.test ]
}

# Create a Launch Template
resource "aws_launch_template" "lt" {
  image_id      = aws_ami_from_instance.test-ami.id # Replace with a valid AMI ID
  instance_type = "t3.micro"
  user_data     = base64encode("#!/bin/bash\\necho 'Hello, World!' > index.html\\nnohup busybox httpd -f -p 80 &") # Example user data to run a simple web server

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

# Create the Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name             = "asg"
  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  # Link the launch template
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  # Specify subnets (replace with your subnet IDs)
  vpc_zone_identifier = [aws_subnet.pub_sub1.id,aws_subnet.pub_sub2.id]

  # Health check settings
  health_check_type         = "EC2"
  health_check_grace_period = 300

}
