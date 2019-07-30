package module

import (
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/stretchr/testify/assert"
)

type Expectations struct {
	CodeSha256 string
}

func RunTestSuite(t *testing.T, lambdaARN, region string, expected Expectations) {
	var (
		config *lambda.FunctionConfiguration
	)
	sess := NewSession(t, region)

	config = GetLambdaConfiguration(t, sess, lambdaARN)
	assert.Equal(t, expected.CodeSha256, aws.StringValue(config.CodeSha256))
}

func NewSession(t *testing.T, region string) *session.Session {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region),
	})
	if err != nil {
		t.Fatalf("failed to create new AWS session: %s", err)
	}
	return sess
}

func GetLambdaConfiguration(t *testing.T, sess *session.Session, lambdaARN string) *lambda.FunctionConfiguration {
	c := lambda.New(sess)

	out, err := c.GetFunctionConfiguration(&lambda.GetFunctionConfigurationInput{
		FunctionName: aws.String(lambdaARN),
	})
	if err != nil {
		t.Fatalf("failed to get lambda configuration: %s", err)
	}

	return out
}
