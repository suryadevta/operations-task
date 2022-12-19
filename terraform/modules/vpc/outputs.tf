output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "public_subnet_c_id" {
  value = aws_subnet.public_subnet_c.id
}

output "public_route_table_id" {
  value = aws_route_table.vpc_public_rt.id
}