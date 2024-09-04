module "aap" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.8.0"

  name                          = var.instanceName
  instance_count                = 1
  
  instance_type                 = var.instanceType
  ami                           = var.ami
  subnet_id                     = tolist(module.vpc.private_subnets)[0]
  key_name                      = var.sshKey
  vpc_security_group_ids        = [module.private_subnet_sg.security_group_id]
  associate_public_ip_address   = false
  ipv6_addresses = null
  private_ips = ["10.0.0.10"]

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

  tags = local.tags
}