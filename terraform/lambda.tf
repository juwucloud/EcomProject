data "archive_file" "order_intake" {
    type        = "zip"
    source_file = "${path.module}/../LambdaFunctions/OrderIntake.py"
    output_path = "${path.module}/lambda_zips/order_intake.zip"
}

resource "aws_lambda_function" "order_intake" {
    filename = data.archive_file.order_intake.output_path
    function_name = "order-intake"
    role = aws_iam_role.lambda_execution_role.arn
    handler = "OrderIntake.lambda_handler"
    runtime = "python3.12"
    source_code_hash = data.archive_file.order_intake.output_base64sha256
}





