provider "aws" {
    region = var.config.region
}

data "aws_caller_identity" "current" {}

resource "aws_key_pair" "sshkeypair" {
  key_name   = var.config.ssh_key
  public_key = file("~/.ssh/${var.config.ssh_key}.pub")
}

locals {
    vpc_cidr                = "10.0.0.0/16" 
    aap_dbname              = "aapdb"

    tags = {
        owner: "Ram Gopinathan"
        email: "ram.gopinathan@redhat.com"

        stack: var.config.name
    }
}