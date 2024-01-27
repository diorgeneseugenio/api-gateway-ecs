

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_exec_role_arn" {
  value = aws_iam_role.ecs_exec_role.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.logs.name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "security_group_id" {
  value = aws_security_group.ecs_task.id
}

output "subnets_id" {
  value = aws_subnet.public[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
output "lb_id" {
  value = aws_lb.main.id
}
