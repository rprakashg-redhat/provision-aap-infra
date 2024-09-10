module "edacontroller" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "2.8.0"

    count = var.config.eda.count

    name                = "edacontroller-node-${count.index}"
     

    instance_type                 = var.config.eda.instance_type
    ami                           = var.config.ami

    subnet_id                     = tolist(module.vpc.private_subnets)[count.index]
    key_name                      = var.config.ssh_key
    vpc_security_group_ids        = [module.private_subnet_sg.security_group_id]
    associate_public_ip_address   = false
    ipv6_addresses = null

    private_ips = [cidrhost(module.vpc.private_subnets_cidr_blocks[count.index], count.index + var.config.controller.count + var.config.hub.count + 10)]
    
    root_block_device = [
        {
        volume_type = "gp2"
        volume_size = 100
        },
    ]

    ebs_block_device = [
        {
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = 50
        encrypted   = false
        }
    ]

    user_data = <<-EOF
        #!/bin/bash
        sudo yum -y update
        sudo dnf -y install ansible-core
        
    EOF
    
    tags = local.tags
}