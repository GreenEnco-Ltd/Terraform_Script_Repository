# To create the Ec2 instance
resource "aws_instance" "Staging_instance" {
  ami                         = var.ami_value           # Change to your desired AMI ID
  instance_type               = var.instance_type_value # Change to your desired instance type
  subnet_id                   = var.public_subnet_id_value
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = aws_key_pair.key_pair.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  count                       = var.instance_count
  vpc_security_group_ids      = [aws_security_group.Staging_security_group.id]
  # Use the user_data variable
  # user_data = var.user_data

  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  # Specify dedicated tenancy for the instance
  placement {
    tenancy = "dedicated"  # Dedicated tenancy for the instance
  }

  tags = {
    Name = "RI-GreenEnco_Staging_Server${count.index}"
  }
}


# Create a security group
resource "aws_security_group" "Staging_security_group" {
  name_prefix = "GreenEnco_Staging_SG"
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