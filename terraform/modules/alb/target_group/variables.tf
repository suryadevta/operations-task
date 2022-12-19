variable "environment" {
    default = "uat"
    description = "environment name"
}

variable "alb_arn" {
    description = "ARN of the application load balancer"
    default = ""
}

variable "alb_tg_name" {
    description = "Name of the application load balancer"
    default = ""
}

variable "vpc_id" {
    description = "ID of the vpc"
    default = ""
}

variable "tg_port" {
    description = "Port number to which the targets are attached to the load balancer"
    default = 0
}

variable "alb_port" {
    description = "Port number to which the alb listener is attached"
    default = 0
}

variable "target_type" {
    description = "Type of the target of target group"
    default = "ip"
}

variable "health_check_path" {
    description = "Path for alb health check"
    default = "/"
}