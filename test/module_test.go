package module_test

import (
	"fmt"
	"strings"
	"testing"

	lambda "github.com/telia-oss/terraform-aws-lambda/v3/test"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestModule(t *testing.T) {
	tests := []struct {
		description string
		directory   string
		name        string
		region      string
		print       string
		expected    lambda.Expectations
	}{
		{
			description: "basic example",
			directory:   "../examples/basic",
			name:        fmt.Sprintf("lambda-basic-test-%s", random.UniqueId()),
			region:      "eu-west-1",
			print:       "hello basic example!",
			expected: lambda.Expectations{
				CodeSha256: "EdQ1V8ceGrd/mSgyi0bIopZ06RXVsiuquX4dkLixjPk=",
			},
		},
		{
			description: "complete example",
			directory:   "../examples/complete",
			name:        fmt.Sprintf("lambda-complete-test-%s", random.UniqueId()),
			region:      "eu-west-1",
			print:       "hello complete example!",
			expected: lambda.Expectations{
				CodeSha256: "OjKCj/Z0Hxid5LoKN8TdPEd3WWXmqY7BOaR6RVwFkpI=",
			},
		},
	}

	for _, tc := range tests {
		tc := tc // Source: https://gist.github.com/posener/92a55c4cd441fc5e5e85f27bca008721
		t.Run(tc.description, func(t *testing.T) {
			t.Parallel()

			options := &terraform.Options{
				TerraformDir: tc.directory,

				Vars: map[string]interface{}{
					// aws_s3_bucket requires a lowercase name.
					"name_prefix": strings.ToLower(tc.name),
					"region":      tc.region,
				},

				EnvVars: map[string]string{
					"AWS_DEFAULT_REGION": tc.region,
				},
			}

			defer terraform.Destroy(t, options)
			terraform.InitAndApply(t, options)

			// Update the print value to trigger an update
			options.Vars["lambda_print_string"] = tc.print
			terraform.InitAndApply(t, options)

			lambda.RunTestSuite(t,
				terraform.Output(t, options, "lambda_arn"),
				tc.region,
				tc.expected,
			)
		})
	}
}
