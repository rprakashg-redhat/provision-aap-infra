provider "aws" {
    region = var.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "http" "whatsmyip" {
    url = "https://api.ipify.org?format=json"

    request_headers = {
      Accept = "application/json"
    }
}

locals {
    azs                     = slice(data.aws_availability_zones.available.names, 0, 3)
    vpc_cidr                = "10.0.0.0/16" 
    elb_name                = "${var.stack}-elb"
    aap_dbnamne             = "aapdb"
    pipeline_name           = "${var.stack}-pipeline"
    install_source_bucket   = "${var.stack}-install-scripts"
    
    my_ip                   = jsondecode(data.http.whatsmyip.response_body)        
    
    tags = {
        owner: "Ram Gopinathan"
        email: "rprakashg@gmail.com"
        website: "https://rprakashg.github.io"
        stack: var.stack
    }
}