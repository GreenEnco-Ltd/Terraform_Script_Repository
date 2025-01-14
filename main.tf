module "vpc" {
  source = "./module/vpc"

  # Pass variables to VPC module
  vpc_id                  = "10.0.0.0/24"
  instance_tenancy        = "dedicated"
  public_subnet_id_value  = "10.0.0.0/28"
  availability_zone       = "eu-north-1a"
  private_subnet_id_value = "10.0.0.16/28"
  availability_zone1      = "eu-north-1b"
}


module "ec2_development" {
  source = "./module/Development_Instance"

  # Pass variables to EC2 module
  ami_value              = "ami-075449515af5df0d1" # data.aws_ami.ubuntu_24_arm.id                            
  instance_type_value    = "t3.large"
  instance_tenancy       = "dedicated"
  key_name               = "GreenEnco_Key.pem"
  instance_count         = "1"
  public_subnet_id_value = module.vpc.public_subnet_id
  availability_zone      = "eu-north-1a"
  vpc_id                 = module.vpc.vpc_id
}


resource "null_resource" "name" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = module.ec2_development.public_ip[0]
  }

  provisioner "file" {
    source      = "./module/Development_Instance/jenkins.sh"
    destination = "/home/ubuntu/jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "export $(grep -v '^#' /home/ubuntu/.env | xargs)",
      "mkdir -p /home/ubuntu/.aws",
      "echo '[default]' > /home/ubuntu/.aws/config",
      "echo 'region = ${var.region}' >> /home/ubuntu/.aws/config",
      "echo '[default]' > /home/ubuntu/.aws/credentials",
      "echo 'aws_access_key_id = ${var.access_key}' >> /home/ubuntu/.aws/credentials",
      "echo 'aws_secret_access_key = ${var.secret_key}' >> /home/ubuntu/.aws/credentials",

      # Optional: Clean up the .env file if not needed
      "rm /home/ubuntu/.env",
      "sudo chmod +x /home/ubuntu/jenkins.sh",
      "sh /home/ubuntu/jenkins.sh"
    ]
  }

  depends_on = [module.ec2_development]
}


# module "ec2_staging" {
#   source = "./module/Staging_Instance"

#   # Pass variables to EC2 module
#   ami_value              = "ami-07a0715df72e58928" # data.aws_ami.ubuntu_24_arm.id                            
#   instance_type_value    = "t3.large"
#   instance_tenancy       = "dedicated"
#   key_name               = var.private_key_path
#   instance_count         = "1"
#   public_subnet_id_value = module.vpc.public_subnet_id
#   availability_zone      = "eu-north-1a"
#   vpc_id                 = module.vpc.vpc_id
# }


# module "ec2_Production" {
#   source = "./module/Production_Instance"

#   # Pass variables to EC2 module
#   ami_value               = "ami-07a0715df72e58928" # data.aws_ami.ubuntu_24_arm.id                            
#   instance_type_value     = "t3.large"
#   instance_tenancy        = "dedicated"
#   key_name                = var.private_key_path
#   instance_count          = "1"
#   private_subnet_id_value = module.vpc.private_subnet_id
#   availability_zone       = "eu-north-1b"
#   vpc_id                  = module.vpc.vpc_id
# }