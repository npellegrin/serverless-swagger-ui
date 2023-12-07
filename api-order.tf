resource "aws_lambda_function" "orders_handler" {
  function_name = "orders-handler"
  role          = aws_iam_role.orders_handler.arn

  filename         = data.archive_file.orders_handler.output_path
  source_code_hash = data.archive_file.orders_handler.output_base64sha256
  handler          = "orders.handler"
  runtime          = "python3.11"
}

data "archive_file" "orders_handler" {
  type        = "zip"
  source_file = "${path.module}/src/orders/orders.py"
  output_path = "${path.module}/dist/orders.zip"
}

resource "aws_iam_role" "orders_handler" {
  name = "orders-handler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "orders_handler" {
  role       = aws_iam_role.orders_handler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "orders_handler" {
  function_name = aws_lambda_function.orders_handler.function_name

  action     = "lambda:InvokeFunction"
  principal  = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
}
