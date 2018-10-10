provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source = "../../"

  name_prefix = "example"
  filename    = "${path.module}/../example.zip"
  runtime     = "python3.6"
  handler     = "example.handler"

  environment {
    TEST = "TEST VALUE"
  }

  tags {
    environment = "prod"
    terraform   = "True"
  }
}

output "lambda_arn" {
  value = "${module.lambda.arn}"
}
