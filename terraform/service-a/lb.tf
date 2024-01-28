resource "aws_security_group" "service_a_lb" {
  name   = "service-a-alb-sg"
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

resource "aws_lb" "service_a" {
  name            = "service-a-lb"
  subnets         = [var.subnets_id[0], var.subnets_id[1]]
  security_groups = [aws_security_group.service_a_lb.id]
}

resource "aws_lb_target_group" "service_a" {
  name        = "service-a-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "service_a" {
  load_balancer_arn = aws_lb.service_a.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.service_a.arn
    type             = "forward"
  }
}
