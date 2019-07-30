# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = aws_lambda_function.main.arn
}

output "invoke_arn" {
  description = " The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration uri."
  value       = aws_lambda_function.main.invoke_arn
}

output "qualified_arn" {
  description = " The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true)."
  value       = aws_lambda_function.main.qualified_arn
}

output "name" {
  description = "The name of the lambda function."
  value       = var.name_prefix
}

output "role_name" {
  description = "The name of the execution role."
  value       = aws_iam_role.main.name
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the execution role."
  value       = aws_iam_role.main.arn
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = concat(aws_security_group.vpc[*].id, [""])[0]
}

