module "shared" {
  source = "./shared"
}

module "service_a" {
  source = "./service-a"

  ecs_task_role_arn         = module.shared.ecs_task_role_arn
  ecs_exec_role_arn         = module.shared.ecs_exec_role_arn
  cloudwatch_log_group_name = module.shared.cloudwatch_log_group_name
  ecs_cluster_id            = module.shared.ecs_cluster_id
  security_group_id         = module.shared.security_group_id
  subnets_id                = module.shared.subnets_id
  vpc_id                    = module.shared.vpc_id
  lb_id                     = module.shared.lb_id

  depends_on = [module.shared]
}

module "service_b" {
  source = "./service-b"

  ecs_task_role_arn         = module.shared.ecs_task_role_arn
  ecs_exec_role_arn         = module.shared.ecs_exec_role_arn
  cloudwatch_log_group_name = module.shared.cloudwatch_log_group_name
  ecs_cluster_id            = module.shared.ecs_cluster_id
  security_group_id         = module.shared.security_group_id
  subnets_id                = module.shared.subnets_id
  vpc_id                    = module.shared.vpc_id
  lb_id                     = module.shared.lb_id

  depends_on = [module.shared]
}

