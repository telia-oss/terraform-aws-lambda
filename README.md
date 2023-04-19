## Lambda function

[![latest release](https://img.shields.io/github/v/release/telia-oss/terraform-aws-lambda?style=flat-square)](https://github.com/telia-oss/terraform-aws-lambda/releases/latest)
[![build status](https://img.shields.io/github/actions/workflow/status/telia-oss/terraform-aws-lambda/main.yml?branch=master&logo=github&style=flat-square)](https://github.com/telia-oss/terraform-aws-lambda/actions/workflows/main.yml)

This module creates a lambda function and takes care of setting up the execution role, in addition to uploading the source code. Note that `source_code_hash` or `s3_object_version` must be set if you want to automatically update the Lambda execution code.
