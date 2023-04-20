provider "aws" {
  region = var.region
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.name_prefix
  force_destroy = true

  tags = {
    environment = "dev"
    terraform   = "True"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.bucket.id
  key    = "lambda.zip"
  source = "${path.module}/lambda.zip"
  etag   = data.archive_file.lambda.output_md5
}

module "lambda" {
  source = "../../"

  name_prefix       = var.name_prefix
  s3_bucket         = aws_s3_bucket.bucket.id
  s3_key            = aws_s3_object.lambda.id
  s3_object_version = aws_s3_object.lambda.version_id
  policy            = data.aws_iam_policy_document.lambda.json
  runtime           = "python3.9"
  handler           = "lambda.handler"
  vpc_id            = data.aws_vpc.main.id
  subnet_ids        = data.aws_subnets.main.ids

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

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
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
    print("${var.lambda_print_string}")
EOF
}
