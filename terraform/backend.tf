terraform {
  backend "s3" {
    bucket = "juwu-terraform-state-bucket"
    key    = "ecommerce/terraform.tfstate"
    region = "eu-central-1"
  }
}
