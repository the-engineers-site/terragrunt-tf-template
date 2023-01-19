resource "aws_s3_bucket" "eks-logs-bucket" {
  bucket = "${var.s3_bucket_name}-vpc"
}