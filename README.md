## Lambda function

[![Build Status](https://travis-ci.com/telia-oss/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/telia-oss/terraform-aws-lambda)

This module creates a lambda function and takes care of setting up the execution role, in addition to uploading the source code. Note that `source_code_hash` or `s3_object_version` must be set if you want to automatically update the Lambda execution code.
