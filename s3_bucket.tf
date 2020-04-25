resource "aws_s3_bucket" "vueslsapp-cf-log" {
  bucket = join("-", ["cf-log", join(".", [var.project_name, var.domain])])
  acl    = "private"


  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }

  tags = {
    Name = var.project_name 
  }
}