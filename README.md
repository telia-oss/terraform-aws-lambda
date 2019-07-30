## Lambda function

[![Build Status](https://travis-ci.com/telia-oss/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/telia-oss/terraform-aws-lambda)

This module creates a lambda function and takes care of setting up the execution role, in addition to uploading the source code. When using `s3_key` and `s3_bucket` the `source_code_hash` _must_ be manually set if you wish to trigger updates.
