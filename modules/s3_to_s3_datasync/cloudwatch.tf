# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "datasync" {
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
  count             = var.enable_logging ? 1 : 0
  name              = "/datasync/${var.name}"
  retention_in_days = 7
}