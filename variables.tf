# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "policy" {
  description = "A policy document for the lambda execution role."
  type        = string
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "The bucket where the lambda function is uploaded."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "The s3 key for the Lambda artifact."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "The object version containing the function's deployment package. Conflicts with filename."
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
  type        = string
  default     = null
}

variable "runtime" {
  description = "Lambda runtime. Defaults to Go 1.x."
  type        = string
  default     = "go1.x"
}

variable "handler" {
  description = "The function entrypoint in your code."
  type        = string
  default     = "main"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 300
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1"
  type        = number
  default     = -1
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "A map that defines environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
