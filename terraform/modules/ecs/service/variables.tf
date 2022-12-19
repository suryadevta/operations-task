variable "name" {
  default     = ""
  description = "ECS service name"
}

variable "environment" {
  default     = "prod"
  description = "Environment"
}

variable "cluster_id" {
  default     = ""
  description = "ECS cluster ID"
}

variable "td_id" {
  default     = ""
  description = "ECS task definition ID"
}

variable "tg_arn" {
  default     = ""
  description = "ALB target group ARN"
}

variable "desired_count" {
  default     = 0
  description = "Desired task count"
}

variable "public_subnet_a_id" {
  description = "ID of public subnet A"
  default     = "public_a_id"
}

variable "public_subnet_b_id" {
  description = "ID of public subnet B"
  default     = "public_b_id"
}

variable "public_subnet_c_id" {
  description = "ID of public subnet C"
  default     = "public_c_id"
}

variable "container_name" {
  default     = ""
  description = "Container Name"
}

variable "container_port" {
  default     = ""
  description = "Container Port"
}

variable "vpc_id" {
  default = ""
  description = "VPC ID"
}

variable "namespace_id" {
  default = ""
  description = "Service discovery namespace ID"
}
