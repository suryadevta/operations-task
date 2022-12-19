# Define ECS task-definition
resource "aws_ecs_task_definition" "task-definition" {
  family                   = "${var.name}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_units
  memory                   = var.memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  container_definitions    = var.container_definition

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}