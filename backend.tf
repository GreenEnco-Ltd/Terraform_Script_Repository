terraform {
  backend "s3" {
    bucket  = "terraform-backupfile-greenenco"
    key     = "env:/terraform.tfstate"
    region  = "eu-north-1" # Replace with your AWS region
    encrypt = true
    # Optionally specify the DynamoDB table for state locking
    # dynamodb_table = "<YOUR_DYNAMODB_TABLE_NAME>"
  }
}