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

Now we can start defining our infrastructure via terraform, first I exported locally my aws keys that I've previously created at IAM, and run `terraform init`, after we initilalized the project, I created the terraform's boilerplate + ECR project, and applied to create our ECR Registry

# 7 
## Terraform
At this point, we get to code a lot! I created all the infrastructure using terraform, you can check it out in [infra folder](./infra/), I've never created an ECS cluster using EC2 and autoscaling groups, it's the part I've spent most of my time with trouble, so I've just used an provided [terraform autoscaling module](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest) and I managed to get EC2 instance working properly. I could created an EC2 instance without autoscaling and registered as an ECS Anywhere instance, but I designed the infrastructure to be less complicated as possible but able to scale without headache, because of that, I taught it's better to stick with autoscaling for now. I created a VPC with 3 subnets, 2 subnets are in different availability zones from us-east-2, so we can deploy our Application Load Balancer, and the last is an private subnet for our EC2 instance, after that we create our ALB with health check, our application does not have any healthcheck path so we can check the initial (and only) page! And finally our ECS Cluster, where our TaskDefinition is only a dummy created taskdefinition so we can update later on CI/CD. We can get our LB Url and general info for CI/CD running an ```terraform output```!

Also with modules structuring, we have more files to manage but the infra can be easily cloned for any reason, like an QA/Staging environment! 

## CI/CD
We are using Github Actions for our CI/CD, fortunely there's a ton of actions available, so the process of writing our yaml file was simple and fast. At our CI/CD we basically have 2 things going on: 
- We dockerize our app and upload to our ECR Registry, we tag our images using the commit SHA, so in that way, we can easily rollback our application if anything goes wrong, and have previously versions stored in the registry.
- We take [task-definition.json](./infra/task-definition.json) and render it with our new image builded, and deploy to our ECS cluster.

With this, the separate file is the source of truth when we are dealing strictly with task definitions in our cluster, but we have the upside to automating our deployment with pipelines!

# 8 
Now we are at bonus task! Migrating data from an mongodb server for another! First I took a look at our structure within MongoDB Compass, after checking it out, I've installed MongoDB database tools:
```shell
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.8.0.deb
sudo apt install ./mongodb-database-tools-*-100.8.0.deb
```

After that, I checked both mongodb version:
```shell
#old database
db.version()
6.0.9

#new database
db.version()
6.0.5
```
As we have same major version, we confirm that we can migrate the data using *mongodump* and *mongorestore* for migrating the database. Looking at our app code, I see that we use the database called *message*, and checking out the database I see two collections, *sensitive_auths* (with 55000 records) and *values* (with 2 records). We need to migrate these two collections! With mongo database tools the task is very easy, first we need to export the database:

```shell
mongodump --uri="$OLD_URI" --db=message
```
This will create a folder called dump/message. Now we just import to our new database with *mongorestore*
```shell
mongorestore --uri="$NEW_URI" --nsInclude=luigima.sensitive_auths dump/message/
```

After that, just update the .env of the app, and commit to github, the pipeline will automatically update the app!