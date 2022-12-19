resource "aws_ecs_service" "ecs-service" {
  name            = "${var.name}-${var.environment}"
  cluster         = var.cluster_id
  task_definition = var.td_id
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = false
    security_groups  = ["${aws_security_group.ecs_service_sg.id}"]
    subnets          = ["${var.private_subnet_a_id}", "${var.private_subnet_b_id}", "${var.private_subnet_c_id}"]
  }

  lifecycle {
    ignore_changes  = [task_definition]
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.name}-${var.environment}-service-sg"
  description = "${var.name}-${var.environment} ecs service security group"
  vpc_id      = var.vpc_id
  tags = {
    Name       = "${var.name}-${var.environment}-service-sg"
    Environment = var.environment
  }
}