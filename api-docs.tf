
resource "aws_lambda_function" "api_docs_handler" {
  function_name = "api-docs-handler"
  role          = aws_iam_role.api_docs_handler.arn

  filename         = data.archive_file.api_docs_handler.output_path
  source_code_hash = data.archive_file.api_docs_handler.output_base64sha256
  handler          = "main.lambda_handler"
  layers           = [aws_lambda_layer_version.api_docs_requirements.arn]
  runtime          = "python3.11"
}

data "archive_file" "api_docs_handler" {
  type        = "zip"
  source_dir  = "${path.module}/src/api-docs"
  output_path = "${path.module}/dist/api-docs-lambda.zip"
}

resource "aws_lambda_layer_version" "api_docs_requirements" {
  layer_name = "api-docs-requirements"

  filename            = "${path.module}/dist/api-docs-requirements.zip"
  source_code_hash    = filebase64sha256("${path.module}/dist/api-docs-requirements.zip")
  compatible_runtimes = ["python3.11"]
}

resource "aws_iam_role" "api_docs_handler" {
  name = "api-docs-handler"

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

resource "aws_iam_role_policy_attachment" "api_docs_handler_cloudwatch_access" {
  role       = aws_iam_role.api_docs_handler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "api_docs_handler_api_gateway_access" {
  role       = aws_iam_role.api_docs_handler.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_lambda_permission" "api_docs_handler" {
  function_name = aws_lambda_function.api_docs_handler.function_name

  action     = "lambda:InvokeFunction"
  principal  = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
}
