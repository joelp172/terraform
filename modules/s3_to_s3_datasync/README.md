## Usage

To sync data from one bucket to another in the SAME account, use the following resources. This will create a datasync task that runs on the specified cron schedule, to sync all content that has changed since the last sync. If its the first time, a full sync is preformed.

```
locals {
  data_sync_destination_bucket = "adarga-production-archived-data"
  data_sync_source_bucket      = aws_s3_bucket.ingst_text.id
}

module "datasync_my_bucket" {
  source              = "../../../../modules/s3_to_s3_datasync"
  name                = local.data_sync_source_bucket
  source_s3_path      = "s3://${local.data_sync_source_bucket}"
  destination_s3_path = "s3://${local.data_sync_destination_bucket}/${local.data_sync_source_bucket}"
  cron_schedule       = "0 12 * * ? *"
}
```

Datasync requires the following policy to be applied once/globally to the account:

```
# Policy to allow DataSync to write logs to CloudWatch
data "aws_iam_policy_document" "datasync_cw_access" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*"
    ]
    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "datasync" {
  policy_document = data.aws_iam_policy_document.datasync_cw_access.json
  policy_name     = "datasync-cloudwatch-policy"
}
```