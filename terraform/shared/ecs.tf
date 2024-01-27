resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}
