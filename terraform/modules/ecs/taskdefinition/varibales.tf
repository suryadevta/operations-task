variable "name" {
  description = "Name of the task definition"
  default = "task_def"
}

variable "environment" {
  description = "Environment name"
}

variable "cpu_units" {
  default     = 256
  description = "Value of task cpu"
}

variable "memory" {
  default     = 512
  description = "Value of task memory"
}

variable "task_role_arn" {
  description = "ARN of the ECS task role"
}

variable "execution_role_arn" {
  description = "ARN of the ECS execution role"
}

variable "container_definition" {
  description = "Path to the container definition json file"
  #default = ""
}