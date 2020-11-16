provider "aws" {
  version = "~> 3.8.0"
  region  = "eu-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::670824338614:role/Terraforming-Local-Admin"
    session_name = "Terraforming"
  }
}