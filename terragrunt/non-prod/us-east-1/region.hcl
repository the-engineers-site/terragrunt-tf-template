locals {
  aws_region = "us-east-1"
  region_tags       = {
    region = "${local.aws_region}"
  }
}