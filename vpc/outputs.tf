output "vpc_id" {
  value = aws_vpc.main.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group[*].id
}

output "db_security_group" {
  value = [aws_security_group.vpc_sg["rds"].id]
}