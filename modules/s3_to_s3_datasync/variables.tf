variable "source_s3_path" {
  type        = string
  description = "S3 source path"
  validation {
    condition     = can(regex("^s3:\\/\\/([^\\/]+)(\\/|\\/(.*?([^\\/]+))){0,}$", var.source_s3_path))
    error_message = "Provide a valid s3 path: s3://bucket/key"
  }
}

variable "destination_s3_path" {
  type        = string
  description = "S3 destination path"
  validation {
    condition     = can(regex("^s3:\\/\\/([^\\/]+)(\\/|\\/(.*?([^\\/]+))){0,}$", var.destination_s3_path))
    error_message = "Provide a valid s3 path: s3://bucket/key"
  }
}

variable "cron_schedule" {
  type        = string
  description = "cron expression"
}

variable "name" {
  type        = string
  description = "Name of the datasync task"
}

variable "enable_logging" {
  type        = bool
  description = "Enable logging task executions to CloudWatch"
  default     = true
}

variable "s3_kms_key" {
  type        = string
  description = "FULL arn of the KMS key to use for s3 bucket encryption. This is needed for cross account"
  default     = ""
}