module "rds" {
    source  = "terraform-aws-modules/rds/aws"
    version = "6.3.1"

    count = length(var.config.db)

    # insert the 1 required variable here
    identifier = var.config.db[count.index].instance_name
    
    engine                  = "postgres"
    engine_version          = "13"
    family                  = "postgres13"
    major_engine_version    = "13"
    instance_class          = "db.t3.xlarge" // For Free tier supported values ["db.t3.micro", "db.t4g.micro"] For AAP requires 4 vCPU and 16GB RAM so using db.t3.xlarge
     
    allocated_storage       =  20
    max_allocated_storage   = 200
    publicly_accessible     = false

    db_name = var.config.db[count.index].db_name
    username = var.config.db[count.index].db_user
    port = 5432
    
    multi_az = "false"
    db_subnet_group_name = module.vpc.database_subnet_group
    vpc_security_group_ids = [module.db_subnet_sg.security_group_id]

    
    maintenance_window              = "Mon:00:00-Mon:03:00"
    backup_window                   = "03:00-06:00"
    enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
    create_cloudwatch_log_group     = true

    backup_retention_period = 1
    skip_final_snapshot     = true
    deletion_protection     = false

    performance_insights_enabled            = true
    performance_insights_retention_period   = 7
    
    create_monitoring_role                  = true 
    monitoring_interval                     = 60
    monitoring_role_name                    = "${var.config.db[count.index].db_name}-monitoring"
    monitoring_role_description             = "Monitoring role for ${var.config.db[count.index].db_name} AWS RDS database"
    monitoring_role_use_name_prefix         = true
    
    # Below setting is required for Ansible Automation Platform
    parameters = [
        {
            name  = "autovacuum"
            value = 1
        },
        {
            name  = "client_encoding"
            value = "utf8"
        },
    ]

    db_option_group_tags = {
        "Sensitive" = "low"
    }
  
    db_parameter_group_tags = {
        "Sensitive" = "low"
    }

    tags = local.tags
}
