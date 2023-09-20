// *** Create a Terraform Repo ***
// Want this video as a guide: https://www.youtube.com/watch?v=cGPyH-PO8vg

// Create project
terraform init


// *** Running Terraform ***
// Cd into ./infra
// Plan
terraform plan
// Apply
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