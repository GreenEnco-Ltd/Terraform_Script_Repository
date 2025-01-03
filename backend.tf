terraform {
  backend "s3" {
    bucket  = "terraform-backupfile1"
    key     = "terraform.tfstate"
    region  = "us-east-1" # Replace with your AWS region
    encrypt = true
    # Optionally specify the DynamoDB table for state locking
    # dynamodb_table = "<YOUR_DYNAMODB_TABLE_NAME>"
  }
}