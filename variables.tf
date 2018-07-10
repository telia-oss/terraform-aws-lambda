# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem."
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

variable "variables" {
  description = "Map of environment variables."
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
