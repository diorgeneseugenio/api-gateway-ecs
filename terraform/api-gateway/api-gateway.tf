resource "aws_apigatewayv2_vpc_link" "http_api_vpc_link" {
  name = "http-api-vpc-link"
  security_group_ids = [
    var.security_group_id
  ]
  subnet_ids = var.subnets_id
}

resource "aws_apigatewayv2_api" "http_api" {
  name = local.name
  protocol_type = "HTTP"
  body = jsonencode(
    {
    openapi = "3.0.1"
    info = {
      title = "${local.name}"
    }
    components = {
      securitySchemes = {
        my-authorizer = {
          type = "oauth2"
          flows = {
          }
          x-amazon-apigateway-authorizer = {
            identitySource = "$request.header.Authorization"
            jwtConfiguration = {
              audience = [
                "${aws_cognito_user_pool_client.user_pool_client.client_secret}"
              ]
              # TODO: look into better parity with AWS
              issuer = "http://localhost:4566/${aws_cognito_user_pool.user_pool.id}"
            }
            type = "jwt"
          }
        }
      }
    }
    paths = {
      "service-a" = {
        get = {
          responses = {
            default = {
              description = "Default response for GET /foodstore/foods/{foodId}"
            }
          }
          x-amazon-apigateway-integration = {
            payloadFormatVersion = "1.0"
            connectionId = "${aws_apigatewayv2_vpc_link.http_api_vpc_link.id}"
            type = "http_proxy"
            httpMethod = "ANY"
            uri = "${var.service_discovery_service_a_arn}"
            connectionType = "VPC_LINK"
          }
        }
        put = {
          responses = {
            default = {
              description = "Default response for PUT /foodstore/foods/{foodId}"
            }
          }
          security = [
            {
              my-authorizer = [
              ]
            }
          ]
          x-amazon-apigateway-integration = {
            payloadFormatVersion = "1.0"
            connectionId = "${aws_apigatewayv2_vpc_link.http_api_vpc_link.id}"
            type = "http_proxy"
            httpMethod = "ANY"
            uri = "${var.service_discovery_service_a_arn}"
            connectionType = "VPC_LINK"
          }
        }
      }
      "/service-b" = {
        get = {
          responses = {
            default = {
              description = "Default response for GET /petstore/pets/{petId}"
            }
          }
          x-amazon-apigateway-integration = {
            payloadFormatVersion = "1.0"
            connectionId = "${aws_apigatewayv2_vpc_link.http_api_vpc_link.id}"
            type = "http_proxy"
            httpMethod = "ANY"
            uri = "${var.service_discovery_service_b_arn}"
            connectionType = "VPC_LINK"
          }
        }
        put = {
          responses = {
            default = {
              description = "Default response for PUT /petstore/pets/{petId}"
            }
          }
          security = [
            {
              my-authorizer = [
              ]
            }
          ]
          x-amazon-apigateway-integration = {
            payloadFormatVersion = "1.0"
            connectionId = "${aws_apigatewayv2_vpc_link.http_api_vpc_link.id}"
            type = "http_proxy"
            httpMethod = "ANY"
            uri = "${var.service_discovery_service_b_arn}"
            connectionType = "VPC_LINK"
          }
        }
      }
    }
    x-amazon-apigateway-cors = {
      allowOrigins = [
        "*"
      ]
      allowHeaders = [
        "*"
      ]
      allowMethods = [
        "*"
      ]
    }
    x-amazon-apigateway-importexport-version = "1.0"
  }
  )
}
