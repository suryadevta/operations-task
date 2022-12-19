# 
# 1. Create an S3 bucket to store state file and Set AWS for the CLI

# 2. Init terraform env (Run only if you are setting up a new env or added new modules to the main.tf)
#     terraform init

# 3. Select the workspace
#     terraform workspace select dev

# 4. Run plan 
#     terraform plan

# 4. Apply
#     terraform apply

# Provider
provider "aws" {
  region  = var.aws_region
 
}

terraform {
  backend "s3" {
    bucket  = "robinder-operations-task-tf-state"
    region  = "eu-west-1"
    profile = "terraform"
    key     = "terraform.tfstate"
  }
}

# VPC
module "vpc" {
  source                = "./modules/vpc"
  environment           = terraform.workspace
  name_prefix           = var.project_name
  vpc_cidr              = "10.170.0.0/16"
  public_subnet_a_cidr  = "10.170.1.0/24"
  public_subnet_b_cidr  = "10.170.2.0/24"
  public_subnet_c_cidr  = "10.170.3.0/24"
}

# Application Load Balancer
locals {
  alb_certificate_mapping = {
    prod    = "arn:aws:acm:${var.aws_region}:642801335081:certificate/ae179d21-68a7-4af2-96f2-ebd7115d1e61"
    staging = "arn:aws:acm:${var.aws_region}:642801335081:certificate/60a158d5-df31-4f53-b5ed-982f505ed67f"
    dev     = ""
  }
  alb_certificate_arn = local.alb_certificate_mapping[terraform.workspace]
}

module "alb" {
  source             = "./modules/alb/alb"
  environment        = terraform.workspace
  vpc_id             = module.vpc.vpc_id
  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id
  public_subnet_c_id = module.vpc.public_subnet_c_id
  certificate_arn    = local.alb_certificate_arn
}

# Target groups
module "rates_target_group" {
  source            = "./modules/alb/target_group"
  alb_tg_name       = "rates"
  environment       = terraform.workspace
  alb_arn           = module.alb.alb_arn
  target_type       = "ip"
  tg_port           = 80
  health_check_path = "/"
  vpc_id            = module.vpc.vpc_id
}

# Listner rules
module "rates_listner_rule" {
  source           = "./modules/alb/listner_rule"
  listener_arn     = module.alb.http_listner_arn
  priority         = 100
  target_group_arn = module.rates_target_group.target_group_arn
  path_pattern     = "/*"
}

# ECS Cluster
module "ecs_cluster" {
  source       = "./modules/ecs/cluster"
  cluster_name = "xeneta-task"
  environment  = terraform.workspace
}

# ECR repos
module "rates_ecr" {
  source    = "./modules/ecs/ecr"
  repo_name = "rates-${terraform.workspace}"
}

# ECS task definitions
data "template_file" "rates_template" {
  template = file("./container-definitions/task-def.json.tmpl")
  vars = {
    image       = "${module.rates_ecr.repo_url}:latest"
    account_id  = data.aws_caller_identity.current.account_id
    region      = var.aws_region
    environment = terraform.workspace
  }
}

# Task definitions
module "rates_task_def" {
  source               = "./modules/ecs/taskdefinition"
  name                 = "rates"
  environment          = terraform.workspace
  container_definition = data.template_file.rates_template.rendered
  cpu_units            = 256
  memory               = 1024
  task_role_arn        = aws_iam_role.ecs_task_def_role.arn
  execution_role_arn   = aws_iam_role.ecs_task_exe_role.arn
}

# Private DNS namespace
module "namespace" {
  source = "./modules/dns/namespace"
  name   = terraform.workspace
  vpc_id = module.vpc.vpc_id
}

# Cloudwatch log groups
resource "aws_cloudwatch_log_group" "rates_log_group" {
  name = "/ecs/rates-${terraform.workspace}"
  retention_in_days = 7
}

#ECS services
module "rates_service" {
  source              = "./modules/ecs/service"
  name                = "rates"
  environment         = terraform.workspace
  cluster_id          = module.ecs_cluster.ecs_cluster_id
  td_id               = module.rates_task_def.task_def_arn
  tg_arn              = module.rates_target_group.target_group_arn
  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id
  public_subnet_c_id = module.vpc.public_subnet_c_id
  container_name      = "rates-${terraform.workspace}"
  container_port      = "3000"
  desired_count       = 1
  vpc_id              = module.vpc.vpc_id
  namespace_id        = module.namespace.namespace_id
}

# Rates service security group rules
resource "aws_security_group_rule" "rates_allow_all_from_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = module.rates_service.security_group_id
  source_security_group_id = module.alb.security_group_id
}

resource "aws_security_group_rule" "rates_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.rates_service.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}

# RDS PostgreSQL DB

resource "random_password" "db_random_password" {
  length           = 20
  special          = false
}

resource "aws_ssm_parameter" "db_password_parameter" {
  name        = "/${terraform.workspace}/database/password"
  description = "DB password"
  type        = "SecureString"
  value       = random_password.db_random_password.result
  tags = {
    environment = terraform.workspace
  }
  lifecycle {
    ignore_changes  = [value]
  }
}

resource "aws_ssm_parameter" "db_host_parameter" {
  name        = "/${terraform.workspace}/database/host"
  description = "DB Host"
  type        = "SecureString"
  value       = module.postgresql.rds_host
  tags = {
    environment = terraform.workspace
  }
  lifecycle {
    ignore_changes  = [value]
  }
}

module "postgresql" {
  source              = "./modules/rds"
  environment         = terraform.workspace
  project_name        = var.project_name
  rds_engine          = "postgres"
  rds_engine_version  = "13.5"
  rds_db_family       = "postgres13"
  rds_instance_type   = "db.t3.micro"
  rds_username        = "postgres"
  rds_password        = aws_ssm_parameter.db_password_parameter.value
  rds_storage_size    = 20
  vpc_id              = module.vpc.vpc_id
  subnet_a_id         = module.vpc.public_subnet_a_id
  subnet_b_id         = module.vpc.public_subnet_b_id
  subnet_c_id         = module.vpc.public_subnet_c_id
}

resource "aws_security_group_rule" "db_ingress_from_rates" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.postgresql.rds_security_group_id
  source_security_group_id = module.rates_service.security_group_id
}
