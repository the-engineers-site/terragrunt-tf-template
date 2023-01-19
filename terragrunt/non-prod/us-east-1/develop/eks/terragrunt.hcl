dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs                            = {
    vpc_id = "fake-vpc-id"
  }
}

terraform {
  source = "."
}

inputs = {
  s3_bucket_name = dependency.vpc.outputs.vpc_id
}