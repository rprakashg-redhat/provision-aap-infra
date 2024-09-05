provider "aws" {
    region = var.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

resource "aws_key_pair" "sshkeypair" {
  key_name   = var.sshKey
  public_key = file("~/.ssh/${var.sshKey}.pub")
}

locals {
    azs                     = slice(data.aws_availability_zones.available.names, 0, 3)
    vpc_cidr                = "10.0.0.0/16" 
    aap_dbnamne             = "aapdb"
        
    tags = {
        owner: "Ram Gopinathan"
        email: "ram.gopinathan@redhat.com"
        website: "https://rprakashg.github.io"

        stack: var.stack
    }
}