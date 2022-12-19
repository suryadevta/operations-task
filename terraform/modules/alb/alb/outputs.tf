output "security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_arn" {
  value = aws_alb.alb.arn
}

output "http_listner_arn" {
  value = aws_alb_listener.http_alb_listener.arn
}

output "dns_name" {
  value = aws_alb.alb.dns_name
}