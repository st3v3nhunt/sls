locals {
  queue_name = replace("aws-lmda-test-sqs-${var.app_version}", ".", "-")
}

resource "aws_lambda_function" "view" {
  function_name = "view"
  s3_bucket     = var.aws_lambda_deployment_bucket
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
  s3_bucket     = var.aws_lambda_deployment_bucket
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
  s3_bucket     = var.aws_lambda_deployment_bucket
  s3_key        = "v${var.app_version}/tf-lambda.zip"
  handler       = "handler.submit"
  runtime       = "nodejs12.x"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      QUEUE_NAME = local.queue_name
    }
  }
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

resource "aws_lambda_permission" "submit" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.submit.execution_arn}/*/*"
}

# create policy with access to s3 and sqs
resource "aws_iam_policy" "policy" {
  name        = "lambda-access-policy-2"
  description = "a policy with access to s3 and sqs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject"
          ],
          "Resource": "arn:aws:s3:::*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "sqs:SendMessage",
              "sqs:DeleteMessage",
              "sqs:ReceiveMessage",
              "sqs:GetQueueAttributes"
          ],
          "Resource": "arn:aws:sqs:*:*:*"
      }
  ]
}
EOF
}

# attach the s3 policy to the lambda role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.policy.arn
}

# create sqs queue
resource "aws_sqs_queue" "terraform_queue" {
  name = local.queue_name
}

# add sqs event source for process lambda
resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.terraform_queue.arn
  function_name    = aws_lambda_function.process.arn
}
