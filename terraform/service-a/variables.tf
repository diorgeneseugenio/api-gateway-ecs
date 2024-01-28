variable "ecs_task_role_arn" {
  type        = string
  description = "value of the ecs_task_role_arn output from the iam module"
}

variable "ecs_exec_role_arn" {
  type        = string
  description = "value of the ecs_exec_role_arn output from the iam module"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "value of the cloudwatch_log_group_name output from the logs module"

}

variable "ecs_cluster_id" {
  type        = string
  description = "value of the ecs_cluster_id output from the ecs module"

}

variable "subnets_id" {
  type        = list(string)
  description = "value of the subnets_id output from the vpc module"
}

variable "vpc_id" {
  type        = string
  description = "value of the vpc_id output from the vpc module"
}

variable "api_gateway_api_id" {
  type        = string
  description = "value of the api_gateway_api_id output from the api-gateway module"
}

variable "private_subnets_id" {
  type        = list(string)
  description = "value of the subnets_id output from the vpc module"
}
