resource "aws_lb_target_group" "test-tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "test-tga1" {
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.test.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test-tga2" {
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.test.id
  port             = 80
}
