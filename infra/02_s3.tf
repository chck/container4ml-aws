variable "aws_bucket" {
  type = string
  description = "The AWS S3 bucket name to create resource in."
}

resource "aws_s3_bucket" "container4ml" {
  bucket = var.aws_bucket
}
