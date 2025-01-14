output "ec2_public_ip" {
  value = module.ec2_development.public_ip[0]
}
