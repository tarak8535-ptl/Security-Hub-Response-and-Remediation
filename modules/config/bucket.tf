resource "aws_s3_bucket" "config_bucket" {
  bucket = "bucket-config-rp"
    force_destroy = true
  
}