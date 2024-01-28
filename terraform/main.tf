module "shared" {
  source = "./shared"
}

module "service_a" {
  source = "./service-a"

  ecs_task_role_arn         = module.shared.ecs_task_role_arn
  ecs_exec_role_arn         = module.shared.ecs_exec_role_arn
  cloudwatch_log_group_name = module.shared.cloudwatch_log_group_name
  ecs_cluster_id            = module.shared.ecs_cluster_id
  subnets_id                = module.shared.subnets_id
  vpc_id                    = module.shared.vpc_id
  api_gateway_api_id        = module.shared.api_gateway_api_id
  private_subnets_id        = module.shared.private_subnets_id

  depends_on = [module.shared]
}

module "service_b" {
  source = "./service-b"

  ecs_task_role_arn         = module.shared.ecs_task_role_arn
  ecs_exec_role_arn         = module.shared.ecs_exec_role_arn
  cloudwatch_log_group_name = module.shared.cloudwatch_log_group_name
  ecs_cluster_id            = module.shared.ecs_cluster_id
  subnets_id                = module.shared.subnets_id
  vpc_id                    = module.shared.vpc_id
  api_gateway_api_id        = module.shared.api_gateway_api_id
  private_subnets_id        = module.shared.private_subnets_id

  depends_on = [module.shared]
}

