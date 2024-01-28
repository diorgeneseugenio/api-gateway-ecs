

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

output "subnets_id" {
  value = aws_subnet.public[*].id
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "api_gateway_api_id" {
  value = aws_apigatewayv2_api.api.id
}

output "private_subnets_id" {
  value = aws_subnet.private[*].id

}
