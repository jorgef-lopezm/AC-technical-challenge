locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "task"
  }
}



resource "aws_ecs_task_definition" "main" {
  family = "${local.prefix}-task-definition"
  container_definitions = templatefile(var.container_definitions_path, {
    app_image        = var.ecr_image
    db_host          = var.db_host
    db_port          = var.db_port
    db_name          = var.db_name
    db_user          = var.db_user
    db_pass          = var.db_pass
    allowed_hosts    = "var.lb_dns_name" # aws_lb.api.dns_name
    log_group_name   = var.log_group_name
    log_group_region = data.aws_region.current.name
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.task_execution_role_arn # aws_iam_role.task_execution_role.arn
  task_role_arn            = var.task_role_arn           # aws_iam_role.task_role.arn
  volume {
    name = "static"
  }

  tags = local.common_tags
}

resource "aws_ecs_service" "app" {
  name            = "${local.prefix}-api"
  cluster         = var.ecs_cluster # aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.main.family
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.ecs_security_groups
    # assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group
    container_name   = "app"
    container_port   = 80
  }
}