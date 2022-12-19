# ECS cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.cluster_name}-${var.environment}"
  tags = {
    Name       = "${var.cluster_name}-${var.environment}"
    Environment = var.environment
  }
}