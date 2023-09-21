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
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

# A policy added to the role
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}