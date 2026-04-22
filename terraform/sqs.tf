## Order Processor DEAD LETTER QUEUE

resource "aws_sqs_queue" "order_processor_dlq" {
  name = "order-processor-dlq"
}

## Order Processor Queue

resource "aws_sqs_queue" "order_processor_queue" {
  name                       = "order-processor-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400

  redrive_policy = jsonencode({
    maxReceiveCount     = 3
    deadLetterTargetArn = aws_sqs_queue.order_processor_dlq.arn
  })
}

## Payment Processor DEAD LETTER QUEUE

resource "aws_sqs_queue" "payment_processor_dlq" {
  name = "payment-processor-dlq"
}

## Payment Processor Queue

resource "aws_sqs_queue" "payment_processor_queue" {
  name                       = "payment-processor-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400

  redrive_policy = jsonencode({
    maxReceiveCount     = 3
    deadLetterTargetArn = aws_sqs_queue.payment_processor_dlq.arn
  })
}

## Inventory Processor DEAD LETTER QUEUE
resource "aws_sqs_queue" "inventory_processor_dlq" {
  name = "inventory-processor-dlq"
}

## Inventory Processor Queue
resource "aws_sqs_queue" "inventory_processor_queue" {
  name                       = "inventory-processor-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400

  redrive_policy = jsonencode({
    maxReceiveCount     = 3
    deadLetterTargetArn = aws_sqs_queue.inventory_processor_dlq.arn
  })
}

## Notifier DEAD LETTER QUEUE
resource "aws_sqs_queue" "notifier_dlq" {
  name = "notifier-dlq"
}

## Notifier Queue
resource "aws_sqs_queue" "notifier_queue" {
  name                       = "notifier-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400

    redrive_policy = jsonencode({
        maxReceiveCount     = 3
        deadLetterTargetArn = aws_sqs_queue.notifier_dlq.arn
    })

