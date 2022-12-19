resource "aws_alb" "alb" {
  name            = "${var.project}-alb-${var.environment}"
  subnets         = [var.public_subnet_a_id, var.public_subnet_b_id, var.public_subnet_c_id]
  security_groups = [aws_security_group.alb_sg.id]
  internal        = false
  idle_timeout    = "90"
  tags = {
    Name       = "${var.project}_alb_${var.environment}"
    Type       = "Public"
    environment = var.environment
  }
}

resource "aws_alb_listener" "http_alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https_alb_listener" {
  count = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable"
      status_code  = "503"
     }
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg-${var.environment}"
  description = "Allow incoming HTTP/HTTPS connections for ALB"
  vpc_id      = var.vpc_id
  tags = {
    Name       = "${var.project}_alb_sg_${var.environment}"
    environment = var.environment
  }
}

resource "aws_security_group_rule" "egress_alb_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ingress_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ingress_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}