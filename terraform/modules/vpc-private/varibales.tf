variable "environment" {
  description = "environment name"
  default     = "dev"
}

variable "project" {
  default = "operations-task"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "172.30.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for the public subnet A"
  default     = "172.30.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for the public subnet B"
  default     = "172.30.2.0/24"
}

variable "public_subnet_c_cidr" {
  description = "CIDR for the public subnet C"
  default     = "172.30.3.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for the private subnet A"
  default     = "172.30.4.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the private subnet B"
  default     = "172.30.5.0/24"
}

variable "private_subnet_c_cidr" {
  description = "CIDR for the private subnet C"
  default     = "172.30.6.0/24"
}
