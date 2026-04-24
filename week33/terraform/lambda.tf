locals {
  python_lambda_function_name = "week33_python_lambda"
  node_lambda_function_name   = "week33_node_lambda"
}

# assume role policy for lambda role
# your execution role needs this to specify that the lambda service can assume it
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# lambda role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "week33_lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
}

# lambda policies
# for now we only need the basic lambda policy
# if we wanted more permissions we would create an inline policy for the role or an aws_iam_role_poilcy_resource or an aws_iam_policy with an aws_iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# lambda function
## use terraform to zip the file
data "archive_file" "python_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/basic-lambda.py"
  output_path = "${path.module}/basic-python-lambda.zip"
}
data "archive_file" "node_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/basic-lambda.js"
  output_path = "${path.module}/basic-node-lambda.zip"
}

# aws will create a log group for you if one isnt specified. the problem is it won't be deleted when you run terraform destory
# Lambda looks for /aws/lambda/<function-name>
#If it exists → it uses it
#If not → it creates it (if permissions allow)
# I think aws now let's you choose the name of the log group
resource "aws_cloudwatch_log_group" "python_lambda_logs" {
  name              = "/aws/lambda/${local.python_lambda_function_name}"
  retention_in_days = 3
}
resource "aws_cloudwatch_log_group" "node_lambda_logs" {
  name              = "/aws/lambda/${local.node_lambda_function_name}"
  retention_in_days = 3
}

resource "aws_lambda_function" "python_lambda" {
  function_name = local.python_lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = data.archive_file.python_lambda_zip.output_path
  runtime       = "python3.11"
  handler       = "basic-lambda.lambda_handler" # filename.handler_function_name
  package_type  = "Zip"                         # defaults to zip
  # default memory size is 128MB

  depends_on = [aws_cloudwatch_log_group.python_lambda_logs] # this way we won't create the lambda before the log group bc that would allow aws to create the log group
}

resource "aws_lambda_function" "node_lambda" {
  function_name = local.node_lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = data.archive_file.node_lambda_zip.output_path
  runtime       = "nodejs18.x"
  handler       = "basic-lambda.handler" # filename.handler_function_name
  package_type  = "Zip"                  # defaults to zip
  # default memory size is 128MB

  depends_on = [aws_cloudwatch_log_group.python_lambda_logs] # this way we won't create the lambda before the log group bc that would allow aws to create the log group
}
