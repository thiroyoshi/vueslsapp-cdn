resource "aws_s3_bucket_policy" "vueslsapp" {
  bucket = join("-", [var.environment, join(".", [var.project_name, var.domain])])
  policy = data.aws_iam_policy_document.vueslsapp.json
}

data "aws_iam_policy_document" "vueslsapp" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [
        join("",["arn:aws:s3:::", join("-", [var.environment, join(".", [var.project_name, var.domain])])]),
        join("/", [join("",["arn:aws:s3:::", join("-", [var.environment, join(".", [var.project_name, var.domain])])]), "*"])
        ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.vueslsapp.iam_arn]
    }
  }
}
