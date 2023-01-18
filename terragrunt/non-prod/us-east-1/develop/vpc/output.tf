resource "aws_ssm_parameter" "vpc-id" {
  name       = "/${var.env_full_name}/network/vpcId"
  type       = "String"
  value      = module.vpc.vpc_id
  depends_on = [module.vpc]
  tags       = var.tags
}