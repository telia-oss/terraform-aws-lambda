# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "aws_lambda_function" "main" {
  count                          = var.attach_vpc_config == "false" && var.filename != "" ? 1 : 0
  function_name                  = var.name_prefix
  description                    = "Terraformed Lambda function."
  filename                       = var.filename
  handler                        = var.handler
  source_code_hash               = base64sha256(file(var.filename))
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  role                           = aws_iam_role.main.arn
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish

  environment {
    variables = var.environment
  }

  tags = merge(var.tags, map("Name", var.name_prefix))
}

resource "aws_lambda_function" "vpc" {
  count                          = var.attach_vpc_config == "true" && var.filename != "" ? 1 : 0
  function_name                  = var.name_prefix
  description                    = "Terraformed Lambda function."
  filename                       = var.filename
  handler                        = var.handler
  source_code_hash               = base64sha256(file(var.filename))
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  role                           = aws_iam_role.main.arn
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish

  vpc_config {
    subnet_ids         = [join(",", var.subnet_ids)]
    security_group_ids = [aws_security_group.vpc.*.id]
  }

  environment {
    variables = var.environment
  }

  tags = merge(var.tags, map("Name", "${var.name_prefix}"))
}

resource "aws_lambda_function" "main_s3" {
  count                          = var.attach_vpc_config == "false" && var.filename == "" ? 1 : 0
  function_name                  = var.name_prefix
  description                    = "Terraformed Lambda function."
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_trigger_updates == true ? data.aws_s3_bucket_object.main.version_id : ""
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  role                           = aws_iam_role.main.arn
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  source_code_hash               = var.source_code_hash

  environment {
    variables = var.environment
  }

  tags = merge(var.tags, map("Name", var.name_prefix))
}

data "aws_s3_bucket_object" "main" {
  bucket = var.s3_bucket
  key    = var.s3_key
}

resource "aws_lambda_function" "vpc_s3" {
  count                          = var.attach_vpc_config == "true" && var.filename == ""  ? 1 : 0
  function_name                  = var.name_prefix
  description                    = "Terraformed Lambda function."
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_trigger_updates == true ? data.aws_s3_bucket_object.main.version_id : ""
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  role                           = aws_iam_role.main.arn
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  source_code_hash               = var.source_code_hash

  vpc_config {
    subnet_ids         = [join(",", var.subnet_ids)]
    security_group_ids = [aws_security_group.vpc.*.id]
  }

  environment {
    variables = var.environment
  }

  tags = merge(var.tags, map("Name", var.name_prefix))
}

resource "aws_security_group" "vpc" {
  count       = var.attach_vpc_config == "true" ? 1 : 0
  name        = "${var.name_prefix}-sg"
  description = "Terraformed security group."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, map("Name", "${var.name_prefix}-sg"))
}

resource "aws_iam_role" "main" {
  name               = "${var.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "main" {
  name   = "${var.name_prefix}-lambda-privileges"
  role   = aws_iam_role.main.name
  policy = var.policy
}
