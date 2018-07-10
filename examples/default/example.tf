provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source = "../../"

  name_prefix = "example"
  filename    = "${path.module}/../example.zip"
  policy      = "${data.aws_iam_policy_document.lambda.json}"
  runtime     = "python3.6"
  handler     = "example.handler"

  variables {
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
