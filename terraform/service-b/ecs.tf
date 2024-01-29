resource "aws_ecs_task_definition" "service-b" {
  family                   = "service-b"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_exec_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name         = "service-b",
    image        = "${aws_ecr_repository.service_b.repository_url}:latest",
    essential    = true,
    portMappings = [{ containerPort = 3002, hostPort = 3002 }],

    environment = [
      { name = "PORT", value = "3002" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = var.cloudwatch_log_group_name,
        "awslogs-stream-prefix" = "service-b"
      }
    },
  }])
}

resource "aws_ecs_service" "service-b" {
  name            = local.name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service-b.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups  = [aws_security_group.service_b.id]
    subnets          = var.private_subnets_id
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_b.arn
    container_name   = "service-b"
    container_port   = 3002
  }
}
