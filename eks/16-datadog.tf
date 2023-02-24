# data "aws_secretsmanager_secret_version" "dd_api_key" {
#   secret_id = "dd_api_key"
# }

# data "aws_caller_identity" "current" {}




# output "dd_api_key" {
#   value     = data.aws_secretsmanager_secret_version.dd_api_key
#   sensitive = true
# }


# # AWS Integration

# data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::464622532012:root"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"

#       values = [
#         "${datadog_integration_aws.sandbox.external_id}"
#       ]
#     }
#   }
# }

# data "aws_iam_policy_document" "datadog_aws_integration" {
#   statement {
#     actions = [
#       "apigateway:GET",
#       "autoscaling:Describe*",
#       "backup:List*",
#       "budgets:ViewBudget",
#       "cloudfront:GetDistributionConfig",
#       "cloudfront:ListDistributions",
#       "cloudtrail:DescribeTrails",
#       "cloudtrail:GetTrailStatus",
#       "cloudtrail:LookupEvents",
#       "cloudwatch:Describe*",
#       "cloudwatch:Get*",
#       "cloudwatch:List*",
#       "codedeploy:List*",
#       "codedeploy:BatchGet*",
#       "directconnect:Describe*",
#       "dynamodb:List*",
#       "dynamodb:Describe*",
#       "ec2:Describe*",
#       "ecs:Describe*",
#       "ecs:List*",
#       "elasticache:Describe*",
#       "elasticache:List*",
#       "elasticfilesystem:DescribeFileSystems",
#       "elasticfilesystem:DescribeTags",
#       "elasticfilesystem:DescribeAccessPoints",
#       "elasticloadbalancing:Describe*",
#       "elasticmapreduce:List*",
#       "elasticmapreduce:Describe*",
#       "es:ListTags",
#       "es:ListDomainNames",
#       "es:DescribeElasticsearchDomains",
#       "events:CreateEventBus",
#       "fsx:DescribeFileSystems",
#       "fsx:ListTagsForResource",
#       "health:DescribeEvents",
#       "health:DescribeEventDetails",
#       "health:DescribeAffectedEntities",
#       "kinesis:List*",
#       "kinesis:Describe*",
#       "lambda:GetPolicy",
#       "lambda:List*",
#       "logs:DeleteSubscriptionFilter",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#       "logs:DescribeSubscriptionFilters",
#       "logs:FilterLogEvents",
#       "logs:PutSubscriptionFilter",
#       "logs:TestMetricFilter",
#       "organizations:Describe*",
#       "organizations:List*",
#       "rds:Describe*",
#       "rds:List*",
#       "redshift:DescribeClusters",
#       "redshift:DescribeLoggingStatus",
#       "route53:List*",
#       "s3:GetBucketLogging",
#       "s3:GetBucketLocation",
#       "s3:GetBucketNotification",
#       "s3:GetBucketTagging",
#       "s3:ListAllMyBuckets",
#       "s3:PutBucketNotification",
#       "ses:Get*",
#       "sns:List*",
#       "sns:Publish",
#       "sqs:ListQueues",
#       "states:ListStateMachines",
#       "states:DescribeStateMachine",
#       "support:DescribeTrustedAdvisor*",
#       "support:RefreshTrustedAdvisorCheck",
#       "tag:GetResources",
#       "tag:GetTagKeys",
#       "tag:GetTagValues",
#       "xray:BatchGetTraces",
#       "xray:GetTraceSummaries"
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "datadog_aws_integration" {
#   name   = "DatadogAWSIntegrationPolicy"
#   policy = data.aws_iam_policy_document.datadog_aws_integration.json
# }

# resource "aws_iam_role" "datadog_aws_integration" {
#   name               = "DatadogAWSIntegrationRole"
#   description        = "Role for Datadog AWS Integration"
#   assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
#   role       = aws_iam_role.datadog_aws_integration.name
#   policy_arn = aws_iam_policy.datadog_aws_integration.arn
# }

# resource "datadog_integration_aws" "sandbox" {
#   account_id = data.aws_caller_identity.current.account_id
#   role_name  = "DatadogAWSIntegrationRole"
# }


# #  Datadog Forwarder Lambda Function 

# resource "aws_cloudformation_stack" "datadog_forwarder" {
#   name         = "datadog-forwarder"
#   capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
#   parameters = {
#     DdApiKeySecretArn = "aa07fbdc96b178ca6d61efc3eaa4ce06",
#     DdSite            = "datadoghq.eu",
#     FunctionName      = "datadog-forwarder"
#   }
#   template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
# }
