output "task_execution_role" {
  value = aws_iam_role.task_execution_role.arn
}

output "task_role" {
  value = aws_iam_role.task_role.arn
}

output "log_group" {
  value = aws_cloudwatch_log_group.ecs_task_logs.name
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main.name
}