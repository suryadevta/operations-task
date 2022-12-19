resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = var.name
  description = "Private route for service discovery"
  vpc         = var.vpc_id
}