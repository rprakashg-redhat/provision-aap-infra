module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.8.0"

  name                          = "bastion"
  instance_count                = 1

  instance_type                 = "t2.medium"
  ami                           = var.ami
  subnet_id                     = tolist(module.vpc.public_subnets)[0]
  key_name                      = var.sshKey
  vpc_security_group_ids        = [module.public_subnet_sg.security_group_id]
  associate_public_ip_address   = true
  ipv6_addresses = null
  private_ips = ["10.0.3.141"]
  
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name

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

  user_data = file("${path.module}/init.sh")

  tags = local.tags
}

# IAM role for bastion node with SSM permissions
resource "aws_iam_role" "bastion_instance_role" {
  name = "BastionInstanceRole"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

# Bastion instance role policy
resource "aws_iam_role_policy" "bastion_instance_policy" {
  name = "BastionInstancePolicy"
  role = aws_iam_role.bastion_instance_role.id

  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:ListBucket",
            "ssm:SendCommand",
            "ssm:ListCommands",
            "ssm:ListCommandInvocations",
            "ssm:GetCommandInvocation"
          ],
          "Resource": "*"
        }
      ]
    }
  EOF
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "BastionInstanceProfile"
  role = aws_iam_role.bastion_instance_role.name
}