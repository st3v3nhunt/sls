provider "aws" {
  region  = "us-east-1"
  profile = "personal-profile"
}

variable "app_version" {
}

resource "aws_lambda_function" "view" {
  function_name = "view"
  s3_bucket     = "aws-lambda-tf"
  s3_key        = "v${var.app_version}/tf-lambda.zip"
  handler       = "handler.view"
  runtime       = "nodejs12.x"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      BUCKET = "aws-lmda-test-bucket"
    }
  }
}

resource "aws_lambda_function" "process" {
  function_name = "process"
  s3_bucket     = "aws-lambda-tf"
  s3_key        = "v${var.app_version}/tf-lambda.zip"
  handler       = "handler.process"
  runtime       = "nodejs12.x"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      BUCKET = "aws-lmda-test-bucket"
    }
  }
}

resource "aws_lambda_function" "submit" {
  function_name = "submit"
  s3_bucket     = "aws-lambda-tf"
  s3_key        = "v${var.app_version}/tf-lambda.zip"
  handler       = "handler.submit"
  runtime       = "nodejs12.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_tf_lambda"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

}

resource "aws_lambda_permission" "view" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.view.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.view.execution_arn}/*/*"
}

resource "aws_lambda_permission" "process" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.process.execution_arn}/*/*"
}

resource "aws_lambda_permission" "submit" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.submit.execution_arn}/*/*"
}
