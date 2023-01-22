<!-- markdownlint-disable MD025 -->
# terraform-aws-sns-topic

> Represents a module to create an SNS topic.

## GitHub Actions used in this repository

This repo comes with two GitHub actions:

1. `validate-and-test-on-pr` triggers when a new PR is created and validates the Terraform configuration by deploying
   all examples into your AWS account. This action includes also variaous static code analyzers.
   The PR should be approved only after the validation has terminated successfully!
2. `release-on-push-to-main` triggers when the code is pushed into `main`. It creates a new PR.
   When you approve it, it will create a new GitHub release and add a new semantic version tag to the merge commit.

*Pre-requisite for the GitHub actions:*

1. To allow GitHub Actions to assume an IAM role for Terraform deployments, add [AWS OIDC Provider](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
to your AWS account.
2. Add a `GitHubActionsDeployRole` to your AWS account with the necessary permissions and a Trust Policy like
3. Add the following secrets to your repo under Settings/Secrets/Actions:
   - DEPLOY_ROLE: e.g. `arn:aws:iam::123456789012:role/GitHubActionsDeployRole`
   - REGION: e.g. `eu-central-1`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<YOUR AWS ACCOUNT>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:<YOUR GITHUB USER NAME>/terraform-aws-sns-topic:*"
                }
            }
        }
    ]
}
```

<!-- BEGIN_TF_DOCS -->
## Example

### Basic

```terraform
module "basic" {
  # to use GitHub as a source:
  # source = "git::https://mjheitland/terraform-aws-sns-topic?ref=1.0.0"

  # do not use this source -- local testing only
  source = "../../"

  name = "basic-example"
}
```

<!-- markdownlint-disable MD033 Allow inline html for generated markdown -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.sns-failure-alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_iam_policy_document.read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_sns_failure_alarm"></a> [enable\_sns\_failure\_alarm](#input\_enable\_sns\_failure\_alarm) | Enable Alarm for SNS failures(failed delivery or subscription due to invalid attribute) | `bool` | `true` | no |
| <a name="input_alarm_topic_arns"></a> [alarm\_topic\_arns](#input\_alarm\_topic\_arns) | Action for Alarm state (SNS arn) | `list(string)` | `[]` | no |
| <a name="input_ok_topic_arns"></a> [ok\_topic\_arns](#input\_ok\_topic\_arns) | Action for OK state of Alarm (SNS arn) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to associate with module resources. Use the terraform-org-hierarchy module to set default tags on the provider. | `map(string)` | `{}` | no |
| <a name="input_failureAlarmThreshold"></a> [failureAlarmThreshold](#input\_failureAlarmThreshold) | Number of SNS failures to cause alarm | `number` | `1` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The ID or alias of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name for resources created with this module. The name can only contain lowercase<br>letters, numbers, and hyphens. It must start with a letter and cannot end with a<br>hyphen. It cannot exceed 30 characters in length. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_failure_alarm"></a> [failure\_alarm](#output\_failure\_alarm) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_read_policy"></a> [read\_policy](#output\_read\_policy) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
| <a name="output_write_policy"></a> [write\_policy](#output\_write\_policy) | n/a |
<!-- END_TF_DOCS -->
