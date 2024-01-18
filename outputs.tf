output "sqs_attributes" {
  description = "All attributes from sqs queue"
  value = aws_sqs_queue.sqs
}

output "sqs_dlq_attributes" {
  description = "All attributes from sqs dlq queue"
  value = aws_sqs_queue.dlq
}