resource "aws_lb_target_group" "service-b" {
  name_prefix = "svc-b-"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 3002
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = 80
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "service-b" {
  load_balancer_arn = var.lb_id
  port              = 3002
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service-b.id
  }
}
