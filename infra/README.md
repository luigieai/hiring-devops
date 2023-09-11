# First time setup
This is the steps for setup infrastructure for hiring-devops project
## Requirements
- Terraform version 1.5.4
- AWS Account with Administrator access
- Actions settings access to this own Github repository

## AWS Setup
First you will need to create an IAM Account in AWS for deploying the infrastructure and the pipeline, after created you will need to get an **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**, these keys will be used in terraform and pipeline for deploying.

After that, create an S3 Bucket, we recommend an versionated bucket so we can rollback our infrastructure if needed with an old .tfstate file.

## Terraform Setup
At [provider.tf](./provider.tf), configure the *backend* and *provider* block with the S3 bucket informations, and AWS region that we will deploy, like this:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "hiringdevops-terraform"
    key    = "infra/hiring-devops"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}
```
After that, you should configure our aws keys, you can use AWS CLI for this 
```shell
aws configure
```
Or you can export the keys directly
```shell
export AWS_ACCESS_KEY_ID=yourkey
export AWS_SECRET_ACCESS_KEY=yourkey
```
Now you can init the project!
```shell
terraform init
```
You should get an sucess message, you can plan the project and if everything sound right, just apply it
```shell
terraform apply
```

If the apply is sucessful, we have our ECS cluster running using one t2.micro EC2 instance and an Application autobalancer, the project will give essentials outputs, like our URL and informations for our pipeline setup, you can always run again with ```terraform output```

## Pipeline setup
First go to the projects *settings* > *Secrets and variables* > *Actions*. Now create two new secrets clicking in the button called *New Repository Secret*, the secrets should be named
- AWS_ACCESS_KEY_ID 
- AWS_SECRET_ACCESS_KEY
- MONGO_URI
And populate the secrets with AWS keys previously created. 

Go ahead to our [pipeline file](../.github/workflows/aws.yml) and configure the Environment Variables with our terraform output informations, an example:
```yaml
env:
  AWS_REGION: us-east-2
  ECR_REPOSITORY: hiring-devops
  ECS_SERVICE: hiring-devops
  ECS_CLUSTER: hiring-devops
  ECS_TASK_DEFINITION: ./infra/task-definition.json
  CONTAINER_NAME: hiring-devops
  IMAGE_TAG: ${{ github.sha }}  
```
If you need to change anything related to Task Definition with our project, just change the [task-definition file](../infra/task-definition.json).

After that, you can commit and push the changes and our pipeline should trigger and already replace our dummy container deploy with our app, and everytime we need to redeploy the app, we should use the pipeline.
