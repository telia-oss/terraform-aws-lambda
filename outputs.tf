# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = "${aws_lambda_function.main.arn}"
}

output "name" {
  description = "The name of the lambda function."
  value       = "${var.name_prefix}-function"
}

output "role_name" {
  description = "The name of the instance role."
  value       = "${aws_iam_role.main.name}"
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the instance role."
  value       = "${aws_iam_role.main.arn}"
}
