output "master_public_ip" {
  description = "The public IP address of the master server"
  value       = aws_instance.master.*.public_ip
}

output "worker_public_ip" {
  description = "The public IP address of the worker server"
  value       = aws_instance.worker.*.public_ip
}