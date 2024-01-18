# m-portal-aws-sqs
This Terraform module facilitates the creation of Amazon Simple Queue Service (SQS) queues in AWS. It supports the creation of both main queues and Dead Letter Queue (DLQ), allowing for detailed configurations and access policies. **For additional resources, examples, and community engagement**, check out the portal [Cloudymos](https://cloudymos.com) :cloud:.
## Usage

```
module "sqs_example" {
  source = "github.com/BOlimpio/m-portal-aws-sqs?ref=v1.0.0""

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

  tags = {
    Environment = "Test",
    Owner = "Cloudymos"
  }
}

``` 

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


| Variable                              | Type           | Description                                                               | Default   | Required  |
| ------------------------------------- | -------------- | ------------------------------------------------------------------------- | --------- | --------- |
| create_queue                          | bool           | Whether to create the SQS queue.                                          | true      | Yes       |
| create_queue_policy                   | bool           | Whether to create a policy for the SQS queue.                             | true      | Yes       |
| name                                  | string         | The name of the SQS queue.                                                |           | Yes       |
| visibility_timeout_seconds            | number         | The duration (in seconds) that the received messages are hidden.         | 30        | No        |
| message_retention_seconds             | number         | The number of seconds that SQS retains a message.                        | 345600    | No        |
| max_message_size                      | number         | The limit of bytes a message can contain before SQS rejects it.          | 262144    | No        |
| delay_seconds                         | number         | The time in seconds that the delivery of messages is delayed.            | 0         | No        |
| receive_wait_time_seconds             | number         | The maximum wait time for receiving a message.                            | 0         | No        |
| policy                                | string         | The JSON policy for the SQS queue.                                        | null      | No        |
| fifo_queue                            | bool           | Boolean designating a FIFO queue.                                         | false     | No        |
| content_based_deduplication           | bool           | Boolean designating content-based deduplication.                         | false     | No        |
| sqs_managed_sse_enabled               | bool           | Boolean designating whether to enable SQS managed server-side encryption.| false    | No        |
| kms_master_key_id                     | string         | The ID of an AWS managed customer master key (CMK) or a custom CMK.      | null      | No        |
| kms_data_key_reuse_period_seconds     | number         | The length of time (in seconds) for which SQS can reuse a data key.       | null      | No        |
| source_queue_policy_documents         | list(string)   | List of IAM policy documents for source queue.                            | []        | No        |
| queue_policy_statements               | list(object)   | List of policy statements for the SQS queue policy.                      | []        | No        |
| enable_redrive_policy                 | bool           | Whether to enable the redrive policy.                                     | false     | No        |
| redrive_max_receive_count             | number         | The number of times a message can be received before moving to the DLQ.  | 5         | No        |
| enable_redrive_allow_policy           | bool           | Whether to enable the redrive allow policy.                               | false     | No        |
| allow_all_source_queues               | bool           | Whether to allow all source queues to access the DLQ.                    | true      | No        |
| source_queue_arns                     | list(string)   | List of source queue ARNs to allow access to the DLQ.                    | []        | No        |
| tags                                  | map(string)    | A mapping of tags to assign to the resource.                              | {}        | No        |

### DLQ Module Input Variables

| Variable                              | Type           | Description                                                               | Default   | Required  |
| ------------------------------------- | -------------- | ------------------------------------------------------------------------- | --------- | --------- |
| create_dlq_queue                       | bool           | Whether to create the Dead Letter Queue (DLQ).                            | false     | Yes       |
| create_dlq_queue_policy                | bool           | Whether to create a policy for the SQS DLQ queue.                         | true      | Yes       |
| dlq_name                              | string         | The name of the Dead Letter Queue (DLQ).                                  | "dlq"     | No        |
| dlq_policy                            | string         | The JSON policy for the Dead Letter Queue (DLQ).                          | null      | No        |
| dlq_enable_redrive_allow_policy        | bool           | Whether to enable the redrive allow policy for the DLQ.                   | false     | No        |
| dlq_allow_all_source_queues            | bool           | Whether to allow all source queues to access the DLQ.                    | true      | No        |
| dlq_source_queue_arns                  | list(string)   | List of source queue ARNs to allow access to the DLQ.                    | []        | No        |
| dlq_source_queue_policy_documents      | list(string)   | List of IAM policy documents for source queue for the DLQ.               | []        | No        |
| dlq_queue_policy_statements            | list(object)   | List of policy statements for the DLQ policy.                             | []        | No        |

### SQS and DLQ IAM Policy Variables

| Variable                              |

 Type           | Description                                                               | Default   | Required  |
| ------------------------------------- | -------------- | ------------------------------------------------------------------------- | --------- | --------- |
| custom_iam_policy_statement           | string         | List of custom policy statements.                                        | ""        | No        |
| producer_principals                   | list(string)   | List of AWS principals allowed to send messages to the SQS queue.        | []        | No        |
| consumer_principals                   | list(string)   | List of AWS principals allowed to receive and delete messages from SQS.  | []        | No        |
| admin_principals                      | list(string)   | List of AWS principals with full access to the SQS queue.                | []        | No        |
| dlq_custom_iam_policy_statement       | string         | List of custom policy statements.                                        | ""        | No        |
| dlq_producer_principals               | list(string)   | List of AWS principals allowed to send messages to the DLQ.              | []        | No        |
| dlq_consumer_principals               | list(string)   | List of AWS principals allowed to receive and delete messages from the DLQ.| []      | No        |
| dlq_admin_principals                  | list(string)   | List of AWS principals with full access to the DLQ.                       | []        | No        |


## Outputs


| Name                   | Description                               |
| ---------------------- | ----------------------------------------- |
| sqs_attributes         | All attributes from SQS queue.            |
| sqs_dlq_attributes     | All attributes from SQS DLQ queue.        |

## How to Use Output Attributes
arn = module.sqs_example.sqs_attributes["arn"]

## License
This project is licensed under the MIT License - see the [MIT License](https://opensource.org/licenses/MIT) file for details.

## Contributing
Contributions are welcome! Please follow the guidance below for details on how to contribute to this project:
1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a pull request