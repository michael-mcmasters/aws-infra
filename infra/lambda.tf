# The actual Lambda
resource "aws_lambda_function" "lambda_terraform_poc_function" {
  filename = "${var.jar_file}"
  function_name = "lambda-terraform-poc"
  role          = aws_iam_role.lambda_role.arn
  handler       = "helloworld.App::handleRequest"

  source_code_hash = "${base64sha256(filebase64(var.jar_file))}"

  runtime = "java17"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# The IAM role the lambda assumes
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  
  # Adds a basic policy to the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# Adds another policy to the role - AWSLambdaBasicExceutionRole, which allows the Lambda to created Cloudwtach logs among other things
resource "aws_iam_role_policy_attachment" "basic_execution_role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# The Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_terraform_poc_function.function_name}"

  retention_in_days = 30
}

# Allows API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_terraform_poc_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}