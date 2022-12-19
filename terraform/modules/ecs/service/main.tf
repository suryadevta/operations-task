resource "aws_ecs_service" "ecs-service" {
  name            = "${var.name}-${var.environment}"
  cluster         = var.cluster_id
  task_definition = var.td_id
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_service_sg.id]
    subnets         = [var.public_subnet_a_id, var.public_subnet_b_id, var.public_subnet_c_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
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

resource "aws_service_discovery_service" "service_discovery" {
  name = var.name
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl = 10
      type = "A"
    }
  }
}