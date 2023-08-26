locals {
  prefix = "${var.project_name}-${terraform.workspace}"
  common_tags = {
    Module = "ecs"
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"

  tags = local.common_tags
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.prefix}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${local.prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${local.prefix}-log-group"

  tags = local.common_tags
}