module "sqs_example" {
  source = "github.com/BOlimpio/m-portal-aws-sqs?ref=v1.0.0"

  # SQS variables
  name                        = "my-sqs-queue"
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 345600  # 4 days
  max_message_size            = 262144  # 256 KiB
  delay_seconds               = 0
  receive_wait_time_seconds   = 0
  fifo_queue                  = false
  content_based_deduplication = false
  sqs_managed_sse_enabled     = false

  kms_master_key_id = module.kms_primary_key.kms_key["key_id"]
  kms_data_key_reuse_period_seconds = 300

  //producer_principals      = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/producer-role"]
  consumer_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloudymos"]
  admin_principals    = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    ]

  # DLQ variables
  create_dlq_queue                   = true

  //dlq_producer_principals      = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dlq-producer-role"]
  dlq_consumer_principals      = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloudymos"]
  dlq_admin_principals         = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    ]

  tags = {
    Environment = "Test",
    Owner = "Cloudymos"
  }
}



# data "aws_iam_policy_document" "custom_sqs_policy" {
#   statement {
#     sid       = "CustomSQSPolicy"
#     effect    = "Allow"
#     actions   = [
#       ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloudymos"]
#     }
#   }
# } 
