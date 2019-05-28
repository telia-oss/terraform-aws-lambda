# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem."
  default     = ""
}

variable "policy" {
  description = "A policy document for the lambda execution role."
}

variable "runtime" {
  description = "Lambda runtime. Defaults to Go 1.x."
  default     = "go1.x"
}

variable "handler" {
  description = "The function entrypoint in your code."
  default     = "main"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = 128
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  default     = 300
}

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of subnet IDs associated with the Lambda function."
  default     = []
}

variable "attach_vpc_config" {
  description = "Set to true in order to set the vpc config using the following variables: subnet_ids and security_group_ids."
  default     = "false"
}

variable "environment" {
  description = "A map that defines environment variables for the Lambda function."
  type        = "map"

  default = {
    NA = "NA"
  }
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = "map"
  default     = {}
}

variable "s3_trigger_updates" {
  description = "Trigger updates to lamda if S3 content has changed"
  default     = "true"
}

variable "s3_object_version" {
  description = "The object version containing the function's deployment package. Conflicts with filename."
  default     = ""
}

variable "s3_bucket" {
  description = "The bucket where the lambda function is uploaded."
  default     = ""
}

variable "s3_key" {
  description = "The s3 key for the Lambda artifact."
  default     = ""
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1"
  default     = -1
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version. Defaults to false."
  default     = "false"
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
  default     = ""
}

variable "tracing_mode" {
  description = "The function's AWS X-Ray tracing configuration: Active | PassThrough. "
  default     = "PassThrough"
}