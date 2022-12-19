resource "aws_alb_target_group" "target-group" {
  name                 = "${var.alb_tg_name}-${var.environment}"
  port                 = var.tg_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = var.target_type
  deregistration_delay = 60
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 3
    path                = var.health_check_path
  }
  tags = {
    Name        = var.alb_tg_name
    Environment = var.environment
  }
}