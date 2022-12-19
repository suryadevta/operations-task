# Create database subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.environment}_subnet_group"
  subnet_ids = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
  tags = {
    Name       = "${var.environment}_subnet_group"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "${var.project_name}-parameter-group-${var.environment}"
  family = var.rds_db_family
}

# Create RDS MySQL database instance
resource "aws_db_instance" "rds_db" {
  allocated_storage         = var.rds_storage_size
  storage_type              = "gp2"
  engine                    = var.rds_engine
  engine_version            = var.rds_engine_version
  instance_class            = var.rds_instance_type
  identifier                = "${var.project_name}-${var.environment}"
  username                  = var.rds_username
  password                  = var.rds_password
  parameter_group_name      = aws_db_parameter_group.rds_parameter_group.name
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot"
  skip_final_snapshot       = false
  deletion_protection       = false
  backup_retention_period   = 7
  storage_encrypted         = false
  publicly_accessible       = true
  tags = {
    Name       = "${var.environment}_db_instance"
    Type       = "private"
    Environment = var.environment
  }
  lifecycle {
    ignore_changes = [password]
  }
}

# Define the security group for database
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg_${var.environment}"
  description = "RDS security group to allow traffic from servers"
  vpc_id      = var.vpc_id
  tags = {
    Name       = "rds_sg_${var.environment}"
    Environment = var.environment
  }
}