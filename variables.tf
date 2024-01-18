variable "create_queue" {
  description = "Whether to create the SQS queue."
  type        = bool
  default     = true
}

variable "create_queue_policy" {
  description = "Whether to create a policy for the SQS queue."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the SQS queue."
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "The duration (in seconds) that the received messages are hidden from the queue."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds that Amazon SQS retains a message."
  type        = number
  default     = 345600 # 4 days
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it."
  type        = number
  default     = 262144 # 256 KB
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue is delayed."
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The maximum wait time for receiving a message from the queue."
  type        = number
  default     = 0
}

variable "policy" {
  description = "The JSON policy for the SQS queue."
  type        = string
  default     = null
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Boolean designating content-based deduplication."
  type        = bool
  default     = false
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean designating whether to enable SQS managed server-side encryption."
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "The ID of an AWS managed customer master key (CMK) for Amazon SQS or a custom CMK."
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again."
  type        = number
  default     = null
}

variable "source_queue_policy_documents" {
  description = "List of IAM policy documents for source queue."
  type        = list(string)
  default     = []
}

variable "queue_policy_statements" {
  description = "List of policy statements for the SQS queue policy."
  type        = list(object({
    sid             = string
    actions         = list(string)
    not_actions     = list(string)
    effect          = string
    resources       = list(string)
    not_resources   = list(string)
    principals      = list(object({ type = string, identifiers = list(string) }))
    not_principals  = list(object({ type = string, identifiers = list(string) }))
    conditions      = list(object({ test = string, values = list(string), variable = string }))
  }))
  default = []
}

# Novas variáveis para redrive policy
variable "enable_redrive_policy" {
  description = "Whether to enable the redrive policy."
  type        = bool
  default     = false
}

variable "redrive_max_receive_count" {
  description = "The number of times a message can be received from the source queue before being moved to the dead-letter queue."
  type        = number
  default     = 5
}

# Novas variáveis para redrive allow policy
variable "enable_redrive_allow_policy" {
  description = "Whether to enable the redrive allow policy."
  type        = bool
  default     = false
}

variable "allow_all_source_queues" {
  description = "Whether to allow all source queues to access the dead-letter queue."
  type        = bool
  default     = true
}

variable "source_queue_arns" {
  description = "List of source queue ARNs to allow access to the dead-letter queue."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}


#########################
##### DLQ Variables #####
#########################

variable "create_dlq_queue" {
  description = "Whether to create the Dead Letter Queue (DLQ)."
  type        = bool
  default     = false
}

variable "create_dlq_queue_policy" {
  description = "Whether to create a policy for the SQS DLQ queue."
  type        = bool
  default     = true
}

variable "dlq_name" {
  description = "The name of the Dead Letter Queue (DLQ)."
  type        = string
  default     = "dlq"
}

variable "dlq_policy" {
  description = "The JSON policy for the Dead Letter Queue (DLQ)."
  type        = string
  default     = null
}

variable "dlq_enable_redrive_allow_policy" {
  description = "Whether to enable the redrive allow policy for the Dead Letter Queue (DLQ)."
  type        = bool
  default     = false
}

variable "dlq_allow_all_source_queues" {
  description = "Whether to allow all source queues to access the Dead Letter Queue (DLQ)."
  type        = bool
  default     = true
}

variable "dlq_source_queue_arns" {
  description = "List of source queue ARNs to allow access to the Dead Letter Queue (DLQ)."
  type        = list(string)
  default     = []
}

variable "dlq_source_queue_policy_documents" {
  description = "List of IAM policy documents for source queue for the Dead Letter Queue (DLQ)."
  type        = list(string)
  default     = []
}

variable "dlq_queue_policy_statements" {
  description = "List of policy statements for the Dead Letter Queue (DLQ) policy."
  type        = list(object({
    sid             = string
    actions         = list(string)
    not_actions     = list(string)
    effect          = string
    resources       = list(string)
    not_resources   = list(string)
    principals      = list(object({ type = string, identifiers = list(string) }))
    not_principals  = list(object({ type = string, identifiers = list(string) }))
    conditions      = list(object({ test = string, values = list(string), variable = string }))
  }))
  default = []
}

################################
##### SQS Policy Variables #####
################################

variable "custom_iam_policy_statement" {
  type        = string
  description = "List of custom policy statements."
  default     = ""
}

variable "producer_principals" {
  description = "List of AWS principals (users or roles) allowed to send messages to the SQS queue."
  type        = list(string)
  default     = []
}

variable "consumer_principals" {
  description = "List of AWS principals (users or roles) allowed to receive and delete messages from the SQS queue."
  type        = list(string)
  default     = []
}

variable "admin_principals" {
  description = "List of AWS principals (users or roles) with full access to the SQS queue."
  type        = list(string)
  default     = []
}

####################################
##### SQS DLQ Policy Variables #####
####################################

variable "dlq_custom_iam_policy_statement" {
  type        = string
  description = "List of custom policy statements."
  default     = ""
}

variable "dlq_producer_principals" {
  description = "List of AWS principals (users or roles) allowed to send messages to the DLQ."
  type        = list(string)
  default     = []
}

variable "dlq_consumer_principals" {
  description = "List of AWS principals (users or roles) allowed to receive and delete messages from the DLQ."
  type        = list(string)
  default     = []
}

variable "dlq_admin_principals" {
  description = "List of AWS principals (users or roles) with full access to the DLQ."
  type        = list(string)
  default     = []
}
