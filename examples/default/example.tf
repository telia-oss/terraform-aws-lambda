terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = ">= 2.17"
  region  = "eu-west-1"
}

module "lambda" {
  source = "../../"

  name_prefix = "example"
  filename    = "${path.module}/../example.zip"
  policy      = data.aws_iam_policy_document.lambda.json
  runtime     = "python3.6"
  handler     = "example.handler"

  environment = {
    TEST = "TEST VALUE"
  }

  tags = {
    environment = "prod"
    terraform   = "True"
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

output "lambda_arn" {
  value = module.lambda.arn
}

output "lambda_invoke_arn" {
  value = module.lambda.invoke_arn
}

