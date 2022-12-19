variable "name" {
    default = "bd-uat-watson"
    description = "ECS service name"
}

variable "environment" {
  default     = "prod"
  description = "Environment"
}

variable "cluster_id" {
  default = ""
  description = "ECS cluster ID"
}

variable "td_id" {
  default = ""
  description = "ECS task definition ID"
}

variable "desired_count" {
  default = 0
  description = ""
}

variable "tg_arn" {
    default = ""
    description = "ALB target group ARN"
}

variable "iam_role_arn" {
    default = ""
    description = "ECS Service IAM role ARN"
}

variable "container_name" {
    default = ""
    description = "Container Name"
}

variable "container_port" {
    default = ""
    description = "Container Port"
}

variable "private_subnet_a_id" {
  description = "ID of private subnet A"
  default     = "private_a_id"
}

variable "private_subnet_b_id" {
  description = "ID of private subnet B"
  default     = "private_b_id"
}

variable "private_subnet_c_id" {
  description = "ID of private subnet C"
  default     = "private_c_id"
}

variable "vpc_id" {
  default = ""
  description = "VPC ID"
}