######################
##### Main Queue #####
######################

resource "aws_sqs_queue" "sqs" {
  name        = var.name

  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  max_message_size            = var.max_message_size
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  sqs_managed_sse_enabled     = var.kms_master_key_id != null ? null : var.sqs_managed_sse_enabled

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = merge(
    var.tags,
    tomap({"Name" = lower("${var.name}")})
  )
}

resource "aws_sqs_queue_redrive_policy" "sqs_redrive_policy" {
  count = var.create_dlq_queue && var.create_queue ? 1 : 0

  queue_url     = aws_sqs_queue.sqs.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.redrive_max_receive_count
  })
}

resource "aws_sqs_queue_policy" "sqs" {
  count = var.create_queue_policy && var.create_queue ? 1 : 0

  queue_url = aws_sqs_queue.sqs.url
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

