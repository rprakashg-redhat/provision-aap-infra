variable config {
  description = "Ansible automation platform deployment config"
  type = object({
    name        = string
    region      = string
    azs         = list(string)
    ami         = string
    base_domain = string
    ssh_key     = string
    my_ip       = string

    controller  = object({
      instance_type = string
      count         = number
    })
    hub         = object({
      instance_type = string
      count         = number
    })
    eda         = object({
      instance_type = string
      count         = number
    })
    execution     = object({
      instance_type = string
      count         = number
    })
    db              = list(object({
      instance_name = string
      db_name       = string
      db_user          = string
    }))
  })
  default = {
    name = "edge-management"
    region = "us-west-2"
    azs    = ["us-west-2a", "us-west-2b"]
    ami = "ami-0f7197c592205b389"
    base_domain = "sandbox1734.opentlc.com"
    ssh_key = "ec2"
    my_ip   = "136.27.40.26/32"

    controller = {
      count = 1
      instance_type = "m5.xlarge"
    }
    hub = {
      count = 1
      instance_type = "m5.large"
    }
    eda = {
      count = 1
      instance_type = "m5.xlarge"
    }
    execution = {
      count = 1
      instance_type = "m5.xlarge"
    }
    db = [
      {
        instance_name = "automationcontroller"
        db_name       = "automationcontrollerdb"
        db_user       = "aapadmin"
      },
      {
        instance_name = "automationhub"
        db_name       = "automationhubdb"
        db_user       = "hubadmin"
      },
    ]
  }
}