# --- ECS Cluster ---
resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}



# --- Cloud Watch Logs ---

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/services"
  retention_in_days = 14
}

# --- ECS Task Definition ---

resource "aws_ecs_task_definition" "service-a" {
  family                   = "service-a"
  task_role_arn            = aws_iam_role.ecs_service_a_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_service_a_exec_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"


  container_definitions = jsonencode([{
    name         = "service-a",
    image        = "${aws_ecr_repository.service_a.repository_url}:latest",
    essential    = true,
    portMappings = [{ containerPort = 3001, hostPort = 3001 }],

    environment = [
      { name = "PORT", value = "3001" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = aws_cloudwatch_log_group.logs.name,
        "awslogs-stream-prefix" = "service-a"
      }
    },
  }])
}

resource "aws_ecs_task_definition" "service-b" {
  family                   = "service-b"
  task_role_arn            = aws_iam_role.ecs_service_b_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_service_a_exec_role.arn
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
        "awslogs-group"         = aws_cloudwatch_log_group.logs.name,
        "awslogs-stream-prefix" = "service-b"
      }
    },
  }])
}
# --- ECS Service ---

resource "aws_security_group" "ecs_task" {
  name_prefix = "ecs-task-sg-"
  description = "Allow all traffic within the VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service-a" {
  name            = "service-a"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service-a.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = aws_subnet.public[*].id
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_target_group.service-a]

  load_balancer {
    target_group_arn = aws_lb_target_group.service-a.arn
    container_name   = "service-a"
    container_port   = 3001
  }
}

resource "aws_ecs_service" "service-b" {
  name            = "service-b"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service-b.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = aws_subnet.public[*].id
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_target_group.service-b]

  load_balancer {
    target_group_arn = aws_lb_target_group.service-b.arn
    container_name   = "service-b"
    container_port   = 3002
  }
}
