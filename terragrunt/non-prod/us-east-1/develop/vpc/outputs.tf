resource "aws_ssm_parameter" "vpc-id" {
  name       = "/${var.env_full_name}/network/vpcId"
  type       = "String"
  value      = module.vpc.vpc_id
  depends_on = [module.vpc]
  tags       = var.tags
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "available_azs" {
  value = module.vpc.azs
}