variable "vpc_id" {
}

variable "subnet_a_id" {
}

variable "subnet_b_id" {
}

variable "subnet_c_id" {
}

variable "environment" {
  default = "dev"
}

variable "project_name" {
  default = ""
}

variable "rds_instance_type" {
  default     = "db.t2.small"
  description = "DB instance type of rds"
}

variable "rds_engine" {
  default     = "postgres"
  description = "RDS DB engine"
}

variable "rds_engine_version" {
  default     = "11.5"
  description = "RDS DB engine version"
}

variable "rds_db_family" {
  default = "postgres11"
}

variable "rds_username" {
  default     = "rds"
  description = "RDS username"
}

variable "rds_password" {
  default     = "password"
  description = "RDS password"
}

variable "rds_storage_size" {
  default     = 50
  description = "Rds storage size"
}