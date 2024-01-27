resource "aws_lb_target_group" "service-a" {
  name_prefix = "svc-a-"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 3001
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

resource "aws_lb_listener" "service-a" {
  load_balancer_arn = var.lb_id
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service-a.id
  }
}
