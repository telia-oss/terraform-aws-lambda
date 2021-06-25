# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "aws_lambda_function" "main" {
  function_name                  = var.name_prefix
  description                    = "Terraformed Lambda function."
  filename                       = var.filename
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  source_code_hash               = var.source_code_hash
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  role                           = aws_iam_role.main.arn
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = aws_security_group.vpc[*].id
  }

  environment {
    variables = var.environment
  }

  layers = var.layers

  tags = merge(var.tags, { "Name" = var.name_prefix })
}

resource "aws_security_group" "vpc" {
  count       = length(var.subnet_ids) > 0 ? 1 : 0
  name        = "${var.name_prefix}-sg"
  description = "Terraformed security group."
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { "Name" = "${var.name_prefix}-sg" })
}

resource "aws_iam_role" "main" {
  name               = "${var.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = merge(var.tags, { "Name" = "${var.name_prefix}-lambda-role" })
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["edgelambda.amazonaws.com", "lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "main" {
  name   = "${var.name_prefix}-lambda-privileges"
  role   = aws_iam_role.main.name
  policy = var.policy
}

