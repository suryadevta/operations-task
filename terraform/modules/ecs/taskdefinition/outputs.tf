output "task_def_arn" {
  value = aws_ecs_task_definition.task-definition.arn
}

output "family" {
  value = aws_ecs_task_definition.task-definition.family
}

output "revision" {
  value = aws_ecs_task_definition.task-definition.revision
}