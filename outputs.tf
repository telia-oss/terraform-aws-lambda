# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = "${element(concat(aws_lambda_function.main.*.arn, aws_lambda_function.vpc.*.arn, aws_lambda_function.main_s3.*.arn, aws_lambda_function.vpc_s3.*.arn,), 0)}"
}

output "name" {
  description = "The name of the lambda function."
  value       = "${var.name_prefix}"
}

output "role_name" {
  description = "The name of the execution role."
  value       = "${aws_iam_role.main.name}"
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the execution role."
  value       = "${aws_iam_role.main.arn}"
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = "${element(concat(aws_security_group.vpc.*.id, list("")), 0)}"
}

output "invoke_arn" {
  description = " The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration uri."
  value       = "${element(concat(aws_lambda_function.main.*.invoke_arn, aws_lambda_function.vpc.*.invoke_arn, aws_lambda_function.main_s3.*.invoke_arn, aws_lambda_function.vpc_s3.*.invoke_arn,), 0)}"
}