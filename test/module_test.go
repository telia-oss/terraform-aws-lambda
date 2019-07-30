package module_test

import (
	"fmt"
	"testing"

	lambda "github.com/telia-oss/terraform-aws-lambda/v3/test"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDefaultExample(t *testing.T) {
	tests := []struct {
		description string
		directory   string
		name        string
		region      string
		expected    lambda.Expectations
	}{
		{
			description: "basic example",
			directory:   "../examples/basic",
			name:        fmt.Sprintf("lambda-basic-test-%s", random.UniqueId()),
			region:      "eu-west-1",
			expected: lambda.Expectations{
				CodeSha256: "G63tPMsN+RicnJfrn43RqldH6TEbTs6d7eYWO5jnMZw=",
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
					"name_prefix": tc.name,
					"region":      tc.region,
				},

				EnvVars: map[string]string{
					"AWS_DEFAULT_REGION": tc.region,
				},
			}

			defer terraform.Destroy(t, options)
			terraform.InitAndApply(t, options)

			lambda.RunTestSuite(t,
				terraform.Output(t, options, "lambda_arn"),
				tc.region,
				tc.expected,
			)
		})
	}
}
