resource "aws_sns_topic" "order-confirmation" {
  name = "order-confirmation-topic"
}

# resource "aws_sns_topic_subscription" "order-confirmation-email" {
#   topic_arn = aws_sns_topic.order-confirmation.arn
#   protocol  = "email"
#   endpoint  = "user@example.com" ## Replace with actual email address
# }

