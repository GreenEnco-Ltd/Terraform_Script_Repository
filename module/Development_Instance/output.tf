output "public_ip" {
  value = aws_instance.Development_Instance[*].public_ip
}