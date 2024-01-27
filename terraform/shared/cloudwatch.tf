resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/services"
  retention_in_days = 14
}
