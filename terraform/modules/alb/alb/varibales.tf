variable "vpc_id" {
}

variable "public_subnet_a_id" {
}

variable "public_subnet_b_id" {
}

variable "public_subnet_c_id" {
}

variable "environment" {
  default = "dev"
}

variable "project" {
  default = "operations-task"
}

variable "alb_health_check" {
  default = "/health"
}

variable "certificate_arn" {
  default = ""
}