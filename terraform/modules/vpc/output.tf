output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
}

output "public_subnets" {
  description = "ID of public subnets"
  value       = aws_subnet.public.id
}

output "master_sg_id" {
  description = "ID of master security group"
  value       = aws_security_group.master_sg.id
}

output "worker_sg_id" {
  description = "ID of worker security group"
  value       = aws_security_group.worker_sg.id
}