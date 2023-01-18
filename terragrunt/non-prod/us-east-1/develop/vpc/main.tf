locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "${var.env_full_name}-vpc"
  cidr = var.vpc.cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc.cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc.cidr, 8, k + 10)]

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  create_egress_only_igw          = true

  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${var.env_full_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${var.env_full_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.env_full_name}-default" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.env_full_name}-eks" = "shared"
    "kubernetes.io/role/elb"                         = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.env_full_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"                = 1
  }

  tags = var.tags
}