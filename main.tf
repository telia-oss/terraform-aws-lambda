# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "aws_lambda_function" "main" {
  function_name    = "${var.name_prefix}"
  description      = "Terraformed Lambda function."
  filename         = "${var.filename}"
  handler          = "${var.handler}"
  source_code_hash = "${base64sha256(file(var.filename))}"
  runtime          = "${var.runtime}"
  memory_size      = "${var.memory_size}"
  timeout          = "${var.timeout}"
  role             = "${aws_iam_role.main.arn}"

  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment {
    variables = "${var.variables}"
  }

  tags = "${merge(var.tags, map("Name", "${var.name_prefix}"))}"
}

resource "aws_iam_role" "main" {
  name               = "${var.name_prefix}-lambda-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
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
  role   = "${aws_iam_role.main.name}"
  policy = "${var.policy}"
}
