locals {
  env_type       = "non-prod"
  account_name   = "dev"
  aws_account_id = "022064385368"
  env_type_tags           = {
    env_type     = "${local.env_type}"
    account_name = "${local.account_name}"
  }
}