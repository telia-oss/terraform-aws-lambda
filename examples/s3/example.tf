provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = "${data.aws_vpc.main.id}"
}

# Basic example which creates a Lambda function from s3 bucket in the default VPC.
module "lambda_vpc" {
  source = "../../"

  name_prefix       = "example-vpc"
  s3_bucket         = "telia-oss"
  s3_key            = "hello-world/helloworld.zip"
  policy            = "${data.aws_iam_policy_document.lambda_vpc.json}"
  runtime           = "python3.6"
  handler           = "helloworld.handler"
  vpc_id            = "${data.aws_vpc.main.id}"
  subnet_ids        = ["${data.aws_subnet_ids.main.ids}"]
  attach_vpc_config = "true"

  environment {
    TEST = "TEST VALUE"
  }

  tags {
    environment = "prod"
    terraform   = "True"
  }
}

data "aws_iam_policy_document" "lambda_vpc" {
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

output "lambda_vpc_arn" {
  value = "${module.lambda_vpc.arn}"
}

output "lambda_vpc_security_group_id" {
  value = "${module.lambda_vpc.security_group_id}"
}

module "lambda" {
  source = "../../"

  name_prefix       = "example-vpc"
  s3_bucket         = "telia-oss"
  s3_key            = "hello-world/helloworld.zip"
  policy            = "${data.aws_iam_policy_document.lambda.json}"
  runtime           = "python3.6"
  handler           = "helloworld.handler"

  environment {
    TEST = "TEST VALUE"
  }

  tags {
    environment = "prod"
    terraform   = "True"
  }
}

output "lambda_security_group_id" {
  value = "${module.lambda.security_group_id}"
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
  value = "${module.lambda.arn}"
}

output "lambda_invoke_arn" {
  value = "${module.lambda.invoke_arn}"
}