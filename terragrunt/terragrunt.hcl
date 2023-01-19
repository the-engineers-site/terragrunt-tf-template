locals {
  # Env type leve variables
  account_vars = read_terragrunt_config(find_in_parent_folders("env-type.hcl"))

  # region level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  versions_vars = read_terragrunt_config(find_in_parent_folders("version.hcl"))

  env_specific_vars = yamldecode(file(find_in_parent_folders("env.yaml")))

  tags = merge(
    local.account_vars.locals.env_type_tags,
    local.region_vars.locals.region_tags,
    local.env_specific_vars.env_tags,
  )

  env_full_name = "${local.env_specific_vars.env_name}-${local.env_specific_vars.env_identifier}"

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}


# Generate an AWS provider block
generate "provider" {
  path      = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.versions_vars.locals.aws_provider_version}"
    }
  }
}
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}


inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.versions_vars.locals,
  local.env_specific_vars,
  { tags = local.tags },
  { env_full_name = local.env_full_name },
)