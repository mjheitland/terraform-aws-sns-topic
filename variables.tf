variable "name" {
  type        = string
  nullable    = false
  description = <<-EOT
    The name for resources created with this module. The name can only contain lowercase
    letters, numbers, and hyphens. It must start with a letter and cannot end with a
    hyphen. It cannot exceed 30 characters in length.
  EOT

  validation {
    condition     = can(regex("^[[:lower:]]+[[:lower:][:digit:]-]+$", var.name))
    error_message = "The name can only contain lowercase letters, numbers, and hyphens. It must start with a letter."
  }

  validation {
    condition     = !can(regex("-$", var.name))
    error_message = "The name cannot end with a hyphen, it only contain lowercase letters, numbers, and hyphens (not trailing). It must start with a letter."
  }

  validation {
    condition     = length(var.name) <= 30
    error_message = "The name must be less than or equal to 30 characters in length."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to associate with module resources. Use the terraform-org-hierarchy module to set default tags on the provider."
}

locals {
  qualified_name = trim(lower(replace(var.name, "/[[:punct:]]|[[:space:]]/", "-")), "-")
  tags           = merge(var.tags, { "ops/module" = "aws/sns-topic", Name = local.qualified_name })
}

variable "enable_sns_failure_alarm" {
  type        = bool
  default     = true
  description = "Enable Alarm for SNS failures(failed delivery or subscription due to invalid attribute)"
}

variable "failureAlarmThreshold" {
  type        = number
  default     = 1
  description = "Number of SNS failures to cause alarm"
}

variable "alarm_topic_arns" {
  type        = list(string)
  default     = []
  description = "Action for Alarm state (SNS arn)"
}

variable "ok_topic_arns" {
  type        = list(string)
  default     = []
  description = "Action for OK state of Alarm (SNS arn)"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "The ID or alias of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK."
}
