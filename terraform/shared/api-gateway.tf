#1: API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "api-gateway"
  protocol_type = "HTTP"
}

#5: APIGW Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}
