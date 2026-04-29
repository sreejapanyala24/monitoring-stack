terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws" # tells terraform to use aws plugin
      version = "~>5.0" # use version 5.x of the plugin
    }
  }
  required_version = ">=1.3.0" # terraform at least be of version 1.3
}
provider "aws" {
  region = var.aws_region # deploy resources in the region
}