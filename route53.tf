# Create an A record in the specified hosted zone
resource "aws_route53_record" "elbrecord" {
  zone_id = data.aws_route53_zone.base_domain.id
  name    = "automation.${var.domain}"
  type    = "A"
  
  # Use alias to point to the ELB
  alias {
    name                   = module.elb.elb_dns_name
    zone_id                = module.elb.elb_zone_id
    evaluate_target_health = true
  }
}