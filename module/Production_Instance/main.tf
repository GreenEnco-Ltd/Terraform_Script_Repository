# To create the Ec2 instance
resource "aws_instance" "Production_instance" {
  ami                         = var.ami_value           # Change to your desired AMI ID
  instance_type               = var.instance_type_value # Change to your desired instance type
  subnet_id                   = var.private_subnet_id_value
  associate_public_ip_address = false         # Enable a public IP 
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  count                       = var.instance_count
  vpc_security_group_ids      = [aws_security_group.Production_security_group.id]
  tenancy                     = var.instance_tenancy    # Specify dedicated tenancy
  # Use the user_data variable
  # user_data = var.user_data

  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }
  
  
  tags = {
    Name = "RI-GreenEnco_Production_Server${count.index}"
  }
}

# # RSA key of size 4096 bits
# resource "tls_private_key" "rsa-4096-example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "key_pair" {
#   key_name   = var.key_name
#   public_key = tls_private_key.rsa-4096-example.public_key_openssh
# }

# resource "local_file" "private_key" {
#   content = tls_private_key.rsa-4096-example.private_key_pem
#   filename = var.key_name
# }


# Create a security group
resource "aws_security_group" "Production_security_group" {
  name_prefix = "GreenEnco_Production_SG"
  description = "Example security group"
  vpc_id      = var.vpc_id

  # Define your security group rules as needed
  # For example, allow SSH and HTTP traffic
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}