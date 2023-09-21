// *** Links ***
// Example repo: https://github.com/danielbryantuk/aws-lambda-terraform-java-play/blob/master/terraform/lambda.tf
// Registry (AWS Terraform Resources): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function


// *** Create a Terraform Repo ***

// Create your project
mkdir my-project
cd my-project

// Add infra directory
// (This step doesn't really matter, but if you want your code to be in the same repo, it's nice to separate infra from the code)
mkdir infra

// Initiate Terraform
cd infra
terraform init


// *** Deploy Terraform ***
cd infra
terraform plan
terraform apply


// *** Upload Zip/Jar ***
// Drop the jar file in the repo.
// Plan/Apply will generate a zip file automatically



// My goals for this repo.

- Learn more about Terraform.
- Provision API Gateway, Lambda Authorizer, Lambda, S3, and DynamoDB.
- Deploy a website using infra from Terraform (if possible - S3 and CloudFront?)
- Enable UI to send request to backend and save to Dynamo, and then fetch from Dynamo and display data.
- Use KMS Keys and understand them.
- Deploy an SSL certificate and understand it.
- Create a base infra that I can re-use if I want to begin another Serverless project.