// *** Deploy Terraform ***
cd infra
terraform plan
terraform apply
// (Note: these command can hang or error. Control + C twice to exit and retry the commands.)

// If you want to upload a new jar to Lambda, simply drag and drop it into this repo and then run "terraform apply".
// Other languages are bit more complicated, you need a zip file containing a deploy package and another Terraform resource. But for Java, all you need is a jar.


// *** Links ***
// Example repo: https://github.com/danielbryantuk/aws-lambda-terraform-java-play/blob/master/terraform/lambda.tf
// Registry (AWS Terraform Resources): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
// Provisioning API Gateway: https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/serverless-with-aws-lambda-and-api-gateway


// *** Things I've Learned about Terraform ***
All of these files are condensed into one. So it doesn't matter where a resource is defined.


// *** Create a New Terraform Repo ***
// (If you wanted to create a new repo instead of using this one)
// Create your project
mkdir my-project
cd my-project

// Add infra directory
// (This step doesn't really matter, but if you want your code to be in the same repo, it's nice to separate infra from the code)
mkdir infra

// Initiate Terraform
cd infra
terraform init


// *** My goals for this repo ***
- Learn more about Terraform.
- Provision API Gateway, Lambda Authorizer, Lambda, S3, and DynamoDB.
- Deploy a website using infra from Terraform (if possible - S3 and CloudFront?)
- Enable UI to send request to backend and save to Dynamo, and then fetch from Dynamo and display data.
- Use KMS Keys and understand them.
- Deploy an SSL certificate and understand it.
- Create a base infra that I can re-use if I want to begin another Serverless project.