output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "rds_host" {
  value = aws_db_instance.rds_db.address
}