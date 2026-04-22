output "api_url" {
  description = "API Gateway URL for order endpoint"
  value       = "${aws_api_gateway_stage.prod.invoke_url}/order"
}

output "dynamodb_table_name" {
  description = "DynamoDB Orders Table Name"
  value       = aws_dynamodb_table.orders.name
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for notifications"
  value       = aws_sns_topic.order-confirmation.arn

}

output "cloudfront_url" {
  description = "CloudFront Distribution URL"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}