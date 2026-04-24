# https://spacelift.io/blog/terraform-api-gateway
# the api container itself
resource "aws_api_gateway_rest_api" "api" {
  name = "Week33-API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# path segments -- parent is the path node the resource sits under so foo.com/user/profile would have foo.com/user as its parent and foo.com/user has foo.com as its parent
resource "aws_api_gateway_resource" "python" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "python"
}
resource "aws_api_gateway_resource" "node" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "node"
}

# because we're using lambda and lambda returns a full http response, we don't need a method_response or integration_response
resource "aws_api_gateway_method" "python_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.python.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "node_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.node.id
  http_method   = "GET"
  authorization = "NONE"
}

# lambda integration
resource "aws_api_gateway_integration" "python_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.python.id
  http_method             = aws_api_gateway_method.python_method.http_method
  integration_http_method = "POST" # this must be post -- In this method, Lambda requires that the POST request be used to invoke any Lambda function.
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.python_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "node_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.node.id
  http_method             = aws_api_gateway_method.node_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.node_lambda.invoke_arn
}

# deployment 

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  lifecycle {
    create_before_destroy = true
  }


  depends_on = [
    aws_api_gateway_integration.node_integration,
    aws_api_gateway_integration.python_integration
  ]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

# permissions
resource "aws_lambda_permission" "api_python" {
  statement_id  = "AllowAPIGWInvokePythonLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*" # allow form any stage, method, resource...
}

resource "aws_lambda_permission" "api_node" {
  statement_id  = "AllowAPIGWInvokeNodeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.node_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*" # allow form any stage, method, resource...
}
