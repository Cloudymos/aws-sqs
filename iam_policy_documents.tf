######################
##### SQS policy #####
######################

data "aws_iam_policy_document" "sqs_policy" {
  source_policy_documents = compact([
      var.custom_iam_policy_statement,
      length(var.producer_principals) > 0 ? data.aws_iam_policy_document.producer_policy[0].json : "",
      length(var.consumer_principals) > 0 ? data.aws_iam_policy_document.consumer_policy[0].json : "",
      length(var.admin_principals) > 0 ? data.aws_iam_policy_document.admin_policy[0].json : "",
    ]
  )
}

data "aws_iam_policy_document" "producer_policy" {
  count = length(var.producer_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid       = "SendOnly"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.sqs.arn]

    principals {
      type        = "AWS"
      identifiers = var.producer_principals
    }
  }
}

data "aws_iam_policy_document" "consumer_policy" {
  count = length(var.consumer_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid       = "ReceiveAndDelete"
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = [aws_sqs_queue.sqs.arn]

    principals {
      type        = "AWS"
      identifiers = var.consumer_principals
    }
  }
}

data "aws_iam_policy_document" "admin_policy" {
  count = length(var.admin_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid = "FullAccess"
    actions = [
      "sqs:*",
    ]
    resources = [aws_sqs_queue.sqs.arn]

    principals {
      type        = "AWS"
      identifiers = var.admin_principals
    }
  }
}

##########################
##### DLQ SQS policy #####
##########################

data "aws_iam_policy_document" "dlq_policy" {
  source_policy_documents = compact([
      var.dlq_custom_iam_policy_statement,
      length(var.dlq_producer_principals) > 0 ? data.aws_iam_policy_document.dlq_producer_policy[0].json : "",
      length(var.dlq_consumer_principals) > 0 ? data.aws_iam_policy_document.dlq_consumer_policy[0].json : "",
      length(var.dlq_admin_principals) > 0 ? data.aws_iam_policy_document.dlq_admin_policy[0].json : "",
    ]
  )
}

data "aws_iam_policy_document" "dlq_producer_policy" {
  count = length(var.dlq_producer_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid       = "DLQSendOnly"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.dlq[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.dlq_producer_principals
    }
  }
}

data "aws_iam_policy_document" "dlq_consumer_policy" {
  count = length(var.dlq_consumer_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid       = "DLQReceiveAndDelete"
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = [aws_sqs_queue.dlq[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.dlq_consumer_principals
    }
  }
}

data "aws_iam_policy_document" "dlq_admin_policy" {
  count = length(var.dlq_admin_principals) > 0 ? 1 : 0

  source_policy_documents = []

  statement {
    sid = "DLQFullAccess"
    actions = [
      "sqs:*",
    ]
    resources = [aws_sqs_queue.dlq[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.dlq_admin_principals
    }
  }
}
