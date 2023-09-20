# The IAM role the lambda assumes
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// A policy added to the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# The jar file you are uploading
# Add your jar file to the project root. Make sure its name is the same as source_file, and Terraform will automatically create a zip file with the name given in output_path
# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "../HelloWorld-1.0.jar"
#   output_path = "../HelloWorld-1.0.zip"
# }

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "../HelloWorldFunction"
#   output_path = "../HelloWorld-1.0.zip"
# }

# The actual Lambda
resource "aws_lambda_function" "test_lambda" {
  # filename = data.archive_file.lambda.output_path
  filename = "../HelloWorld-1.0.jar"
  function_name = "lambda-terraform-poc"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "helloworld.App::handleRequest"

  # source_code_hash = data.archive_file.lambda.output_base64sha256
  # source_code_hash = filebase64sha256(
    # data.archive_file.lambda.output_path
  # )
  source_code_hash = "${base64sha256(filebase64("../HelloWorld-1.0.jar"))}"

  runtime = "java17"

  environment {
    variables = {
      foo = "bar"
    }
  }
}