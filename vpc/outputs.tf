output "vpc_id" {
  value = aws_vpc.main.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group[*].id
}

output "db_security_group" {
  value = [aws_security_group.rds_sg.id]
}

output "ecs_security_group" {
  value = [aws_security_group.ecs_sg.id]
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "bastion_security_group" {
  value = [aws_security_group.bastion_sg.id]
}