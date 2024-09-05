output "bastion_ip" {
  description = "Public IP of Bastion node"
  value = module.bastion.public_ip
}

output "bastion_dns" {
  description = "Public DNS name of bastion node"
  value = module.bastion.public_dns
}