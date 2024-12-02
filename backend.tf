#aws-infra-terraform-96134153922

terraform {
  backend "s3" {
    bucket = "aws-infra-terraform-96134153922"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}