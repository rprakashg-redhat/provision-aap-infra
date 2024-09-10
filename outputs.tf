output "bastion_ip" {
  description = "Public IP of Bastion node"
  value = module.bastion.public_ip
}

output "bastion_dns" {
  description = "Public DNS name of bastion node"
  value = module.bastion.public_dns
}

output "controller_endpoint" {
  description = "URL to access automation controller"
  value = module.elb.elb_dns_name
}

output "eda_ip" {
  description = "Event Driven Ansible Controller IP"
  value = module.edacontroller.*.private_ip
}

output "eda_dns" {
  description = "Event Driven Ansible Controller DNS"
  value = module.edacontroller.*.private_dns
}

output "hub_ip" {
  description = "Private automation hub IP"
  value = module.automationhub.*.private_ip
}

output "hub_dns" {
  description = "Private automation hub DNS"
  value = module.automationhub.*.private_dns
}

output "controller_instances" {
  value = module.automationcontroller.*.id
}