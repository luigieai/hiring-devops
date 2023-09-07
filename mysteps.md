# 1
Decoded the mongodb user at .env, the text was encoded via base64 so it's easible decoded.
# 2
Got an error 
```shell
Error [MongooseError]: The `uri` parameter to `openUri()` must be a string, got "undefined". Make sure the first parameter to `mongoose.connect()` or `mongoose.createConnection()` is a string.
```
I noticed that the apps tries to use process.env.MONGODB_ADDON_URI but in .env it's written MONGODB_ADDOM_URI (ADDOM instead of ADDON), I just fixed the typo

# 3 
I was getting connection error while trying to connect to the database, so I just turned ssl mode to true, and now the app is connecting (`message?ssl=true` )

# 4 
As the app can connect with database, now I'm receving some warns that blocks the moongose library to work: 
```shell
(node:25872) Warning: Accessing non-existent property 'count' of module exports inside circular dependency
(Use `node --trace-warnings ...` to show where the warning was created)
(node:25872) Warning: Accessing non-existent property 'findOne' of module exports inside circular dependency
(node:25872) Warning: Accessing non-existent property 'remove' of module exports inside circular dependency
(node:25872) Warning: Accessing non-existent property 'updateOne' of module exports inside circular dependency
```
When I wan the app with --trace-warnings flag, I noticed that the warnings comes from mongoDB driver, and can be resolved updating the driver version. I ran `npm update mongoose` and tried to run the app again to see if the updated version of ORM does not break anything, now I just have one warning

```shell
(node:27167) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
(Use `node --trace-warnings ...` to show where the warning was created)
Ok #yay!
```
I took the freedom to add the desired option to the mongodb constructor so we avoid breaking future versions, after that I just opened localhost:3000 in my browser and Successfully see the two ending values, now we need head to dockerize the app & deploying at AWS

# 5
I created Dockerfile, run a localtest to check if the image is running correctly, with the successful test, I'm creating first the infrastructure related to the image build (ECR + pipeline)

# 6 
Crated [./infra folder](./infra/) that contains our terraform files, we'll be using terraform to provision our infrastructure resources to allow our app be hosted via an ECS cluster. But before we can automate, we need to setup our AWS account so we can use terraform on it.

I created an IAM Account, with permissions for deploying so we can use as user service for our automation, after that, we need to create a S3 bucket so we can store our tfstate file from terraform, I created one named *hiringdevops-terraform*. Now we just need to configure at our provider:

```hcl
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket     = "hiringdevops-terraform"
    key        = "infra/hiring-devops"
    region     = "us-east-2"
  }

}

provider "aws" {
  region     = "us-east-2"
}
```

Now we can start defining our infrastructure via terraform, first I exported locally my aws keys that I've previously created at IAM, and run `terraform init`, after sucessfuly initilalized the project, I created the terraform's boilerplate + ECR project, and applied to create our ECR Registry