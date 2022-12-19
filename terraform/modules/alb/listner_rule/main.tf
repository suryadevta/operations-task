resource "aws_lb_listener_rule" "listner-rule" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = ["${var.path_pattern}"]
    }
  }

  # condition {
  #   host_header {
  #     values = var.host_headers
  #   }
  # }
}