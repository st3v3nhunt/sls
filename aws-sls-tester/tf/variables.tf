variable "app_version" {
  description = "application version"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_creds_profile" {
  default     = "personal-profile"
  description = "aws profile name"
}

variable "aws_lambda_deployment_bucket" {
  default     = "aws-lambda-tf"
  description = "name of bucket containing the packaged function"
}
