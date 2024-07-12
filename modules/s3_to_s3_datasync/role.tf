// Access role to the S3 buckets
resource "aws_iam_role" "datasync_bucket_access_role" {
  name = "datasync-${var.name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "datasync.amazonaws.com"
        }
      },
    ]
  })
}

// Policy to access the S3 buckets
data "aws_iam_policy_document" "datasync" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [
      "arn:aws:s3:::${local.source_bucket}",
      "arn:aws:s3:::${local.destination_bucket}"
    ]
  }
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${local.source_bucket}/*",
      "arn:aws:s3:::${local.destination_bucket}/*"
    ]
  }
  dynamic "statement" {
    # If a KMS key is provided, add the necessary permissions
    # Required for DataSync to use the KMS key if cross account
    for_each = length(var.s3_kms_key) > 0 ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = [
        var.s3_kms_key
      ]
    }
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy" "datasync" {
  name   = "datasync_s3_access"
  role   = aws_iam_role.datasync_bucket_access_role.name
  policy = data.aws_iam_policy_document.datasync.json
}

