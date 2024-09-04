terraform {
  required_providers {
     aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
    acme = {
      source = "vancluever/acme"
      version = "2.21.0"
    }
  }
}