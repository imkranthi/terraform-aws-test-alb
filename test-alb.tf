provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0b7417c037d3b736f","subnet-08379ffadd1a6be7e"]
}

resource "aws_lb_target_group" "example" {
  name_prefix       = "test"
  port              = 80
  protocol          = "HTTP"
  vpc_id            = "vpc-08fd6d9e9b79fc0c9"
  target_type       = "instance"
  health_check {
    protocol     = "HTTP"
    path         = "/"
    port         = "traffic-port"
    interval     = 30
    timeout      = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_elb" "example" {
  #load_balancer_arn = aws_lb.example.arn
  #target_group_arn  = aws_lb_target_group.example.arn
  instances       = ["i-0b73c6d866fe1dd5a","i-0b7120b20f0e8990f"]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}

