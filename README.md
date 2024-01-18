# m-portal-aws-sqs
This Terraform module facilitates the creation of Amazon Simple Queue Service (SQS) queues in AWS. It supports the creation of both main queues and Dead Letter Queue (DLQ), allowing for detailed configurations and access policies. **For additional resources, examples, and community engagement**, check out the portal [Cloud Collab Hub](https://cloudcollab.com) :cloud:.
## Usage
**Loading...** ⌛
For more detailed examples and use cases, check out the files in the how-to-usage directory. They provide additional scenarios and explanations for leveraging the features of the aws_sqs module.

## Features

Below features are supported:

  * Creates an SQS queue.
  * Optionally creates a DLQ.
  * Pre-configured Key policy for producers, consumers, and administrators.
  * Supports custom policies
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 4.0 |

## Inputs



## Outputs

| Name | Description |
|------|-------------|
| this\_sqs\_queue\_arn | The ARN of the SQS queue |
| this\_sqs\_queue\_id | The URL for the created Amazon SQS queue |
| this\_sqs\_queue\_name | The name of the SQS queue |

