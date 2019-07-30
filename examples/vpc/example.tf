terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = ">= 2.17"
  region  = "eu-west-1"
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}

module "lambda" {
  source = "../../"

  name_prefix       = "example-vpc"
  filename          = "${path.module}/../example.zip"
  policy            = data.aws_iam_policy_document.lambda.json
  runtime           = "python3.6"
  handler           = "example.handler"
  vpc_id            = data.aws_vpc.main.id
  subnet_ids        = data.aws_subnet_ids.main.ids
  attach_vpc_config = true

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
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
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

