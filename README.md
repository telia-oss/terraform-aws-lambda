## Lambda function

[![workflow](https://github.com/telia-oss/terraform-aws-lambda/workflows/workflow/badge.svg)](https://github.com/telia-oss/terraform-aws-lambda/actions)

This module creates a lambda function and takes care of setting up the execution role, in addition to uploading the source code. Note that `source_code_hash` or `s3_object_version` must be set if you want to automatically update the Lambda execution code.
