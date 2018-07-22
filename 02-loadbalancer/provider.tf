provider "aws" {
  profile = "default"
  region  = "us-east-1"
  version = "1.28.0"
}

data "terraform_remote_state" "eks" {
  backend = "local"

  config {
    path = "${path.module}/../01-install/terraform.tfstate"
  }
}
