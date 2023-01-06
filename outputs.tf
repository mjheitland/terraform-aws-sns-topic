output "name" {
  value = aws_sns_topic.topic.name
}

output "arn" {
  value = aws_sns_topic.topic.arn
}

output "url" {
  value = aws_sns_topic.topic.id
}

output "write_policy" {
  value = {
    arn      = aws_iam_policy.write.arn
    document = aws_iam_policy.write.policy
  }
}

output "read_policy" {
  value = {
    document = data.aws_iam_policy_document.read.json
  }
}

output "failure_alarm" {
  value = {
    arn = var.enable_sns_failure_alarm ? aws_cloudwatch_metric_alarm.sns-failure-alarm[0].arn : null
    id  = var.enable_sns_failure_alarm ? aws_cloudwatch_metric_alarm.sns-failure-alarm[0].id : null
  }
}
