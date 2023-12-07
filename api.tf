resource "aws_api_gateway_rest_api" "this" {
  name        = "serverless-swagger-ui"
  description = "This is a simple API Gateway to demonstrate the use of Swagger UI"

  body = templatefile("${path.module}/api-gateway-definition.yaml",
    {
      region_name            = data.aws_region.current.name
      orders_handler_arn     = aws_lambda_function.orders_handler.arn
      api_docs_handler_arn   = aws_lambda_function.api_docs_handler.arn
    }
  )

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "v1"
}
