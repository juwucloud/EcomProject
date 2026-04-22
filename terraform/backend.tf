terraform {
  backend "s3" {
    bucket = "juwu-terraform-state-bucket". ## custom name
    key    = "ecommerce/terraform.tfstate"
    region = "eu-central-1"
  }
}
