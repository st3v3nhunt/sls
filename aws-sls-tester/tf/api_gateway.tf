resource "aws_api_gateway_rest_api" "view" {
  name        = "View"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "view" {
  rest_api_id = aws_api_gateway_rest_api.view.id
  parent_id   = aws_api_gateway_rest_api.view.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "view" {
  rest_api_id   = aws_api_gateway_rest_api.view.id
  resource_id   = aws_api_gateway_resource.view.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "view" {
  rest_api_id = aws_api_gateway_rest_api.view.id
  resource_id = aws_api_gateway_method.view.resource_id
  http_method = aws_api_gateway_method.view.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.view.invoke_arn
}

resource "aws_api_gateway_deployment" "view" {
  depends_on = [
    aws_api_gateway_integration.view
    # aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.view.id
  stage_name  = "test"
}

output "base_url_view" {
  value = aws_api_gateway_deployment.view.invoke_url
}

resource "aws_api_gateway_rest_api" "submit" {
  name        = "submit"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "submit" {
  rest_api_id = aws_api_gateway_rest_api.submit.id
  parent_id   = aws_api_gateway_rest_api.submit.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "submit" {
  rest_api_id   = aws_api_gateway_rest_api.submit.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "submit" {
  rest_api_id = aws_api_gateway_rest_api.submit.id
  resource_id = aws_api_gateway_method.submit.resource_id
  http_method = aws_api_gateway_method.submit.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.submit.invoke_arn
}

resource "aws_api_gateway_deployment" "submit" {
  depends_on = [
    aws_api_gateway_integration.submit
    # aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.submit.id
  stage_name  = "test"
}

output "base_url-submit" {
  value = aws_api_gateway_deployment.submit.invoke_url
}

# resource "aws_api_gateway_rest_api" "process" {
#   name        = "process"
#   description = "Terraform Serverless Application Example"
# }

# resource "aws_api_gateway_resource" "process" {
#   rest_api_id = aws_api_gateway_rest_api.process.id
#   parent_id   = aws_api_gateway_rest_api.process.root_resource_id
#   path_part   = "hello"
# }

# resource "aws_api_gateway_method" "process" {
#   rest_api_id   = aws_api_gateway_rest_api.process.id
#   resource_id   = aws_api_gateway_resource.process.id
#   http_method   = "GET"
#   authorization = "NONE"
# }
# resource "aws_api_gateway_integration" "process" {
#   rest_api_id = aws_api_gateway_rest_api.process.id
#   resource_id = aws_api_gateway_method.process.resource_id
#   http_method = aws_api_gateway_method.process.http_method

#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = aws_lambda_function.process.invoke_arn
# }

# resource "aws_api_gateway_deployment" "process" {
#   depends_on = [
#     aws_api_gateway_integration.process
#     # aws_api_gateway_integration.lambda_root,
#   ]

#   rest_api_id = aws_api_gateway_rest_api.process.id
#   stage_name  = "test"
# }

# output "base_url-submit" {
#   value = aws_api_gateway_deployment.process.invoke_url
# }
