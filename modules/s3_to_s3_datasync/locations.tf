// Source location as S3 Bucket and subdirectory
data "aws_s3_bucket" "source" {
  bucket = local.source_bucket
}

resource "aws_datasync_location_s3" "source" {
  s3_bucket_arn = data.aws_s3_bucket.source.arn
  subdirectory  = local.source_subdirectory
  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_bucket_access_role.arn
  }
}

// Destination location as S3 Bucket and subdirectory
data "aws_s3_bucket" "destination" {
  bucket = local.destination_bucket
}

resource "aws_datasync_location_s3" "destination" {
  s3_bucket_arn = data.aws_s3_bucket.destination.arn
  subdirectory  = local.destination_subdirectory
  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_bucket_access_role.arn
  }
}