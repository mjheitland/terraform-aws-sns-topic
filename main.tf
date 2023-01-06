data "aws_iam_policy_document" "write" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.topic.arn
    ]
  }
}

data "aws_iam_policy_document" "read" {
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:Receive",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes"
    ]
    resources = [
      aws_sns_topic.topic.arn
    ]
  }
}

resource "aws_sns_topic" "topic" {
  name              = local.qualified_name
  kms_master_key_id = var.kms_key
  tags              = merge(local.tags, { "ops/module-primary" : "aws/sns-topic" })
}

resource "aws_iam_policy" "write" {
  name        = "${local.qualified_name}-sns-write"
  path        = "/ops/"
  description = "Allow write to ${local.qualified_name}"

  policy = data.aws_iam_policy_document.write.json

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "sns-failure-alarm" {
  count = var.enable_sns_failure_alarm ? 1 : 0

  alarm_name        = "${local.qualified_name}-snsFailureAlarm"
  alarm_description = "${local.qualified_name} sns failures"
  actions_enabled   = true

  alarm_actions = var.alarm_topic_arns
  ok_actions    = var.ok_topic_arns

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.failureAlarmThreshold
  treat_missing_data  = "notBreaching"

  # conflicts with metric_query
  metric_query {
    id = "failedDelivery"

    metric {
      metric_name = "NumberOfNotificationsFailed"
      namespace   = "AWS/SNS"
      period      = 60
      stat        = "Sum"

      dimensions = {
        TopicName = local.qualified_name
      }
    }
  }

  metric_query {
    id = "invalidAttributes"

    metric {
      metric_name = "NumberOfNotificationsFilteredOut-InvalidAttributes"
      namespace   = "AWS/SNS"
      period      = 60
      stat        = "Sum"

      dimensions = {
        TopicName = local.qualified_name
      }
    }
  }

  metric_query {
    id = "failedDlq"

    metric {
      metric_name = "NumberOfNotificationsFailedToRedriveToDlq"
      namespace   = "AWS/SNS"
      period      = 60
      stat        = "Sum"

      dimensions = {
        TopicName = local.qualified_name
      }
    }
  }

  metric_query {
    id = "snsFailures"

    expression  = "(invalidAttributes + failedDelivery + failedDlq)"
    label       = "SNS failures (invalid attributes, failed DLQ, failed delivery)"
    return_data = "true"
  }
}
