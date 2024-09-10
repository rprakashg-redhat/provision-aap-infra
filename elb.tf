module "elb" {
    source  = "terraform-aws-modules/elb/aws"
    version = "4.0.2"

    name                  = "${var.config.name}-elb"
    subnets               = module.vpc.public_subnets
    security_groups       = [module.public_subnet_sg.security_group_id]

    listener = [
        {
            instance_port       = "443"
            instance_protocol   = "https"
            lb_port             = "443"
            lb_protocol         = "https"
            ssl_certificate_id  = aws_acm_certificate.cert.id
        },
    ]

    health_check = {
        target              = "TCP:80"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
    }

    access_logs = {
        bucket = module.elblogs.s3_bucket_id
        interval = 60
    }

    number_of_instances     = var.config.controller.count
    create_elb              = true 
    instances               = flatten([
                                for k, v in module.automationcontroller: [
                                    for i in v.id: i
                                ] 
                            ])

    #Tag you are it
    tags                  = local.tags
}