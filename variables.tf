variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "stack" {
  description = "Name of Stack"
  type        = string
  default     = "edge-management"
}

variable instanceName {
  description = "EC2 instance name"
  type        = string
  default     = "aap-controller-node"
}

variable "instanceType" {
  description = "EC2 instance type to use"  
  type = string
  default = "m5.xlarge"
}

variable "dbUser" {
  description = "value"
  type        = string
  default     = "aapuser"   
}

variable sshKey {
  description = "SSH key pair name"
  type        = string
  default     = "ec2"
}

variable "ami" {
  description = "AMI to use"
  type = string
  default = "ami-0f7197c592205b389"
}

variable "myip" {
  description = "Public IP assigned by my ISP"
  type        = string
  default     = "136.27.40.16/32"
}

variable "domain" {
  description   = "value"
  type          = string
  default       = "imagebuilder.sandbox1066.opentlc.com"
}