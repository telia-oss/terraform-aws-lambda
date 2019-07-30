terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = ">= 2.17"
  region  = var.region
}

module "lambda" {
  source = "../../"

  name_prefix      = var.name_prefix
  filename         = "${path.module}/lambda.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  policy           = data.aws_iam_policy_document.lambda.json
  runtime          = "python3.6"
  handler          = "lambda.handler"

  environment = {
    TEST = "TEST VALUE"
  }

  tags = {
    environment = "dev"
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

data "archive_file" "lambda" {
  type                    = "zip"
  output_path             = "${path.module}/lambda.zip"
  source_content_filename = "lambda.py"
  source_content          = <<EOF
def handler(event, context):
    print("Hello world!")
EOF
}
