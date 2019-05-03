provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source = "../../"

  name_prefix = "example"
  s3_bucket   = "telia-oss"
  s3_key      = "hello-world/helloworld.zip"
  policy      = "${data.aws_iam_policy_document.lambda.json}"
  runtime     = "python3.6"
  handler     = "helloworld.handler"
  publish     = "true"

  environment {
    TEST = "TEST VALUE"
  }

  tags {
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
  value = "${module.lambda.arn}"
}

output "lambda_invoke_arn" {
  value = "${module.lambda.invoke_arn}"
}

output "lambda_qualified_arn" {
  value = "${module.lambda.qualified_arn}"
}
