resource "aws_datasync_task" "this" {
  destination_location_arn = aws_datasync_location_s3.destination.arn
  name                     = var.name
  source_location_arn      = aws_datasync_location_s3.source.arn
  options {
    bytes_per_second  = -1
    posix_permissions = "NONE"
    uid               = "NONE"
    gid               = "NONE"
    log_level         = var.enable_logging ? "BASIC" : "OFF"
    verify_mode       = "ONLY_FILES_TRANSFERRED"
  }
  schedule {
    schedule_expression = "cron(${var.cron_schedule})"
  }
  # Conditionally create the CloudWatch Log Group
  cloudwatch_log_group_arn = var.enable_logging ? aws_cloudwatch_log_group.datasync[0].arn : null
}