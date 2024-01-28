resource "aws_security_group" "service_b_lb" {
  name   = "service-b-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "service_b" {
  name            = "service-b-lb"
  subnets         = [var.subnets_id[2], var.subnets_id[3]]
  security_groups = [aws_security_group.service_b_lb.id]
}

resource "aws_lb_target_group" "service_b" {
  name        = "service-b-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "service_b" {
  load_balancer_arn = aws_lb.service_b.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.service_b.arn
    type             = "forward"
  }
}
