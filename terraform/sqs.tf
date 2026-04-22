## Order Processor DEAD LETTER QUEUE

resource "aws_sqs_queue" "order_processor_dlq" {
  name = "order-processor-dlq"
}

## Order Processor Queue

resource "aws_sqs_queue" "order_processor_queue" {
  name                       = "order-processor-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400

  redrive_allow_policy = jsonencode({
    maxReceiveCount     = 3
    deadLetterTargetArn = aws_sqs_queue.order_processor_dlq.arn
  })
}



