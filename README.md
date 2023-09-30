## Deploy Terraform
```
cd infra
terraform init   // Only run this command if you don't have an ./infra/.terraform.lock.hcl file locally
terraform plan
terraform apply
```

To deploy a new jar file, simply replace the existing jar file with your new jar file.

If you want to deploy another runtime, such as JavaScript, it's a bit more complicated where you'll need a deployment package (just a folder structure) and will need to zip it using another Terraform resource. Luckily this isn't needed for jars.


## Common Errors
Terraform Plan / Apply commands are hanging:
<br />
These commands seem to hang 50% of the time. Simply Control + C twice to exit and then retry.

Can't find schema:
<br />
You will get this error ocasionally. It has something to do with the Terraform AWS provider. Simply re-run the command and it will go through eventually.

Error: Failed to load plugin schemas:
<br />
This occurs randomly when the AWS provider doesn't respond to Terraform. Just re-run your command and it should go away eventually.

Error: Error acquiring the state lock
<br />
This occurs when a previous terraform command never stopped. Terraform "locks" any more commands from running because it thinks someone else is running an apply and doesn't want you to conflict with it. In VSCode, right clicking the terminal and killing it fixed it for me. You can also follow the directions on this page: https://stackoverflow.com/questions/62189825/terraform-error-acquiring-the-state-lock-conditionalcheckfailedexception
<br />
Be careful with this. I ignored this error and Terraform state went out of sync. I had to go into the console and manually destroy resources to get everything running again.

## Resources
A lot of this repo comes from the following documentation

Example repo:
<br />
https://github.com/danielbryantuk/aws-lambda-terraform-java-play/blob/master/terraform/lambda.tf

Registry (AWS Terraform Resources):
<br />
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

Provisioning API Gateway:
<br />
https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/serverless-with-aws-lambda-and-api-gateway

Deploying a frontend website:
<br />
https://dev.to/aws-builders/how-to-deploy-a-serverless-website-with-terraform-5677

## Create a New Terraform Repo
(If you wanted to create a new repo from scratch instead of using this one)

Create your project
```
mkdir my-project
cd my-project
mkdir infra    // Create a sub-folder to separate your infra from your main codebase if using one repo
```

Initiate Terraform
```
cd infra
terraform init
```

## What I've Learned
All of these files are condensed into one. So it doesn't matter where a resource is defined.

As long as you're fine with a randomly generated DNS name, you can deploy a protected website easily with HTTPS and a signed certificate.
<br />
If you want your own domain, you will need to buy it at Route53 and get a signed certificate.


## My goals for this repo
- Learn more about Terraform.
- Provision API Gateway, Lambda Authorizer, Lambda, S3, and DynamoDB.
- Deploy a website using infra from Terraform (if possible - S3 and CloudFront?)
- Enable UI to send request to backend and save to Dynamo, and then fetch from Dynamo and display data.
- Use KMS Keys.
- Deploy an SSL certificate.
- Create a base infra that I can re-use if I want to begin another Serverless project.
