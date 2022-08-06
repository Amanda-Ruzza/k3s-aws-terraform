# ----- networking/outputs.tf ---- 

output "vpc_id" {
  value = aws_vpc.k3s_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.k3s_rds_subnetgroup.*.name #The '*' will enable access to all of the Subnet Groups created
}

output "db_security_group" {
  value = [aws_security_group.k3s_public_sg["rds"].id]
}

output "public_sg" {
  value = aws_security_group.k3s_public_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.k3s_public_subnet.*.id
}