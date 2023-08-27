locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "ecs"
  }
}

# Creating ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"

  tags = local.common_tags
}

# Create IAM Role for the task execution role
resource "aws_iam_role" "task_execution_role" {
  name               = "${local.prefix}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

# Allows to write logs and pull image from ecr
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create IAM role for the task role 
resource "aws_iam_role" "task_role" {
  name               = "${local.prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

# Create log group for the tasks
resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${local.prefix}-log-group"

  tags = local.common_tags
}

# Task definition
resource "aws_ecs_task_definition" "main" {
  family = "${local.prefix}-task-definition"
  container_definitions = templatefile(var.container_definitions_path, {
    app_image        = var.ecr_image
    db_host          = var.db_host
    db_port          = var.db_port
    db_name          = var.db_name
    db_user          = var.db_user
    db_pass          = var.db_pass
    allowed_hosts    = var.lb_dns_name
    log_group_name   = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region = data.aws_region.current.name
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  volume {
    name = "static"
  }

  tags = local.common_tags
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "${local.prefix}-app"
  cluster         = aws_ecs_cluster.main.name
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