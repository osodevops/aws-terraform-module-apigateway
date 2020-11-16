terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "detected-670824338614-tf-state-eu-west-2"
    key            = "apigw/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-2"
    role_arn       = "arn:aws:iam::670824338614:role/Terraforming-Local-Admin"
  }
}