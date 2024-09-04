module "rds" {
    source  = "terraform-aws-modules/rds/aws"
    version = "6.3.1"

    # insert the 1 required variable here
    identifier = "postgresql"

    engine                  = "postgres"
    engine_version          = "12"
    family                  = "postgres12"
    major_engine_version    = "12"
    instance_class          = "db.t4g.micro" // For Free tier supported values ["db.t3.micro", "db.t4g.micro"]
     
    allocated_storage       =  20
    max_allocated_storage   = 100
    publicly_accessible     = false

    db_name = local.aap_dbnamne
    username = var.dbUser
    port = 5432
    

    db_subnet_group_name = module.vpc.database_subnet_group
    vpc_security_group_ids = [module.db_subnet_sg.security_group_id]

    multi_az = "false"

    maintenance_window              = "Mon:00:00-Mon:03:00"
    backup_window                   = "03:00-06:00"
    enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
    create_cloudwatch_log_group     = true

    backup_retention_period = 0

    performance_insights_enabled            = true
    performance_insights_retention_period   = 7
    create_monitoring_role                  = true 
    monitoring_interval                     = 60
    monitoring_role_name                    = "${local.aap_dbnamne}-monitoring"
    monitoring_role_description             = "Monitoring role for ${local.aap_dbnamne} AWS RDS database"
    monitoring_role_use_name_prefix         = true

    tags = local.tags
}