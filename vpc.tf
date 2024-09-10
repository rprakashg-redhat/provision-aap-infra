module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.8.1"

    name = "${var.config.name}-vpc"

    cidr = local.vpc_cidr
    azs  = var.config.azs

    private_subnets         = [for k, v in var.config.azs : cidrsubnet(local.vpc_cidr, 8, k)]
    public_subnets          = [for k, v in var.config.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
    database_subnets        = [for k, v in var.config.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]
    
    create_database_subnet_group = true
    manage_default_network_acl    = false
    manage_default_route_table    = false
    manage_default_security_group = false

    enable_nat_gateway      = true
    single_nat_gateway      = true
    enable_dns_hostnames    = true

    # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
    enable_flow_log                      = true
    create_flow_log_cloudwatch_log_group = true
    create_flow_log_cloudwatch_iam_role  = true
    flow_log_max_aggregation_interval    = 60

    tags = local.tags
}