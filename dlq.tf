#####################
##### DLQ Queue #####
#####################

resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq_queue ? 1 : 0

  name        = "${var.name}-dlq"

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
    tomap({"Name" = lower("${var.name}-dlq")})
  )
}

resource "aws_sqs_queue_redrive_allow_policy" "dlq_redrive_allow_policy" {
  count = var.create_dlq_queue ? 1 : 0

  queue_url        = aws_sqs_queue.dlq[0].id
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.sqs.arn]
  })
}

resource "aws_sqs_queue_policy" "dlq" {
  count = var.create_dlq_queue ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].url
  policy    = data.aws_iam_policy_document.dlq_policy.json
}
