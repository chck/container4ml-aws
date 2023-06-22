variable "network" {
  type = map(string)
  default = {
    name = "vpc-container4ml"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0.1"
  
  name = var.network.name
  cidr = "10.0.0.0/16"
  azs            = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
 
  enable_dns_hostnames = true
  enable_dns_support   = true

  # enable_ipv6 = true
  # public_subnet_assign_ipv6_address_on_creation = true
  # public_subnet_ipv6_prefixes   = [0, 1, 2]
  # private_subnet_ipv6_prefixes  = [3, 4, 5]
  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnet_tags = {
    Name = "overridden-name-public"
  }
  vpc_tags = {
    Name = var.network.name
  }
}

resource "aws_security_group" "allow_elasicache" {
  name        = "${var.network.name}-allow-elasticache"
  description = "Allow access to Elasticache from VPC Connector"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Access to Elasticache from VPC Connector"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}