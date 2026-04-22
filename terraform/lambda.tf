## Lambda-Function for Order Intake

data "archive_file" "order_intake" {
  type        = "zip"
  source_file = "${path.module}/../LambdaFunctions/OrderIntake.py"
  output_path = "${path.module}/lambda_zips/order_intake.zip"
}

resource "aws_lambda_function" "order_intake" {
  filename         = data.archive_file.order_intake.output_path
  function_name    = "order-intake"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "OrderIntake.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.order_intake.output_base64sha256

  environment {
    variables = {
      ORDERS_TABLE    = aws_dynamodb_table.orders.name
      ORDER_QUEUE_URL = aws_sqs_queue.order_processor_queue.url
    }
  }
}

## Lambda-Function for Order Processing

data "archive_file" "order_processor" {
  type        = "zip"
  source_file = "${path.module}/../LambdaFunctions/OrderProcessor.py"
  output_path = "${path.module}/lambda_zips/order_processor.zip"
}

resource "aws_lambda_function" "order_processor" {
  filename         = data.archive_file.order_processor.output_path
  function_name    = "order-processor"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "OrderProcessor.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.order_processor.output_base64sha256

  environment {
    variables = {
      ORDERS_TABLE        = aws_dynamodb_table.orders.name
      PAYMENT_QUEUE_URL   = aws_sqs_queue.payment_processor_queue.url
      INVENTORY_QUEUE_URL = aws_sqs_queue.inventory_processor_queue.url
    }
  }
}

## Lambda-Function for Payment Processing

data "archive_file" "payment_processor" {
  type        = "zip"
  source_file = "${path.module}/../LambdaFunctions/PaymentProcessor.py"
  output_path = "${path.module}/lambda_zips/payment_processor.zip"
}

resource "aws_lambda_function" "payment_processor" {
  filename         = data.archive_file.payment_processor.output_path
  function_name    = "payment-processor"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "PaymentProcessor.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.payment_processor.output_base64sha256

  environment {
    variables = {
      ORDERS_TABLE           = aws_dynamodb_table.orders.name
      NOTIFICATION_QUEUE_URL = aws_sqs_queue.notifier_queue.url
    }
  }
}

## Lambda-Function for Inventory Processing
data "archive_file" "inventory_processor" {
  type        = "zip"
  source_file = "${path.module}/../LambdaFunctions/InventoryProcessor.py"
  output_path = "${path.module}/lambda_zips/inventory_processor.zip"
}

resource "aws_lambda_function" "inventory_processor" {
  filename         = data.archive_file.inventory_processor.output_path
  function_name    = "inventory-processor"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "InventoryProcessor.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.inventory_processor.output_base64sha256

  environment {
    variables = {
      ORDERS_TABLE           = aws_dynamodb_table.orders.name
      NOTIFICATION_QUEUE_URL = aws_sqs_queue.notifier_queue.url
    }
  }
}

## Lambda-Function for Notifier 
data "archive_file" "notifier" {
  type        = "zip"
  source_file = "${path.module}/../LambdaFunctions/Notifier.py"
  output_path = "${path.module}/lambda_zips/notifier.zip"
}

resource "aws_lambda_function" "notifier" {
  filename         = data.archive_file.notifier.output_path
  function_name    = "notifier"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "Notifier.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.notifier.output_base64sha256

  environment {
    variables = {
      ORDERS_TABLE  = aws_dynamodb_table.orders.name
      SNS_TOPIC_ARN = aws_sns_topic.order-confirmation.arn
    }
  }
}





