package test

import (
	"crypto/tls"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	files "github.com/gruntwork-io/terratest/modules/files"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	random "github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var bucketName = "jzdemo"
var project = os.Getenv("GOOGLE_PROJECT")
var uniqueID = strings.ToLower(random.UniqueId())

func TestStaticPageModule(t *testing.T) {
	module := "modules/static_page"

	expectedBucketName := fmt.Sprintf("%s-%s", bucketName, uniqueID)
	expectedURL := fmt.Sprintf("https://storage.googleapis.com/%s/index.html", expectedBucketName)

	files.CopyFile("versions.tf", module+"/versions.tf") // Include the root module versions file

	/*
	* The next part configures the Terraform executor, and passes
	* any variables to the configuration (otherwise set in .tfvars).
	* Afterwards, the configuration initiates Terraform and attempts
	* to apply any changes.
	 */

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: module,
		NoColor:      false,
		Vars: map[string]interface{}{
			"project":       project,
			"bucket_name":   bucketName,
			"bucket_suffix": uniqueID,
		},
	})

	defer terraform.Destroy(t, terraformOptions) // Destroy resources on completion, regardless of outcome

	terraform.Init(t, terraformOptions)
	terraform.WorkspaceSelectOrNew(t, terraformOptions, "terratest")
	terraform.Apply(t, terraformOptions)

	/*
	* The next part fetches module's outputs and runs assertion
	* tests on them, to ensure naming and URL's have been constructed
	* correctly.
	 */

	outputBucketName := terraform.Output(t, terraformOptions, "bucket_name")
	outputURL := terraform.Output(t, terraformOptions, "page_url")

	assert.Equal(t, expectedBucketName, outputBucketName)
	assert.Equal(t, expectedURL, outputURL)

	/*
	* The next part executes a HTTP GET request to the exposed endpoint,
	* to verify that the exposed content matches what's provisioned.
	* It expects the request to return 200 OK with the module's page_content
	* as the body.
	 */

	outputContent := terraform.Output(t, terraformOptions, "page_content")

	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	tlsConfig := tls.Config{}

	http_helper.HttpGetWithRetry(t, outputURL, &tlsConfig, 200, outputContent, maxRetries, timeBetweenRetries)
}
