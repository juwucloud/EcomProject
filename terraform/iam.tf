## Lambda Execution Role 
resource "aws_iam_role" "lambda_execution_role" {
  name = "ecommerce-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


## DynamoDB policy 

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "lambda-dynamodb-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.orders.arn
      }
    ]
  })
}


## SQS policy 
resource "aws_iam_policy" "sqs_access_policy" {
  name = "lambda-sqs-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect = "Allow"
        Resource = [
          aws_sqs_queue.order_processor_queue.arn,
          aws_sqs_queue.payment_processor_queue.arn,
          aws_sqs_queue.inventory_processor_queue.arn,
          aws_sqs_queue.notifier_queue.arn
        ]
      }
    ]
  })
}

## SNS policy 

resource "aws_iam_policy" "sns_access_policy" {
  name = "lambda-sns-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = aws_sns_topic.order-confirmation.arn
      }
    ]
  })
}

## Policy Attachments 

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.sns_access_policy.arn
}




