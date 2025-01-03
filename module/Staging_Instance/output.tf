output "public_ip" {
  value = aws_instance.Staging_instance[*].public_ip
}