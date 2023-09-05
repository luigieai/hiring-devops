# Recruitment for Meteor DevOps Engineer

This task is intended for candidates applying for the DevOps Engineer position on the Meteor team.

The main objective of the assignment is to see how you work with technologies related to DevOps and Troubleshooting.

We are delighted that you are considering joining us. The challenge below should serve as an entry point into a good technical interview discussion.

## Introduction

Meteor is running a core application serving our customers. This application has stopped working due to changes that were made locally without using git.

Now we versioned this repository and we need to put this application back online, the person who was responsible is no longer in the company and we need your help to solve this problem.

Requirements for the test:

1. - AWS Free tier account - Link [AWS](https://aws.amazon.com/pt/free/)

* Requirements to run application:

1. - `NodeJs 18.14.1`
2. - `MongoDB ` No need to create MongoDB Infrastructure

To install node dependencies simply run:
```
$ npm install
```

And to run the application locally:

```
$ npm start
```

## The Challenge

The task consists of solving and discovering the problems why the application does not start.

Your job is to

1. Dockerize the application
2. Set up CI/CD for the repository
    - 2.1. Any push to the `main` branch should deploy the application.
    - 2.2. We recommend using GitHub Actions or GitLab CI.
3. Deploy container to AWS
    - 3.1. The deployed application should be accessible via the internet, don't worry the URL can be that of the AWS loadbalancer.
    - 3.2. You can use: Terraform or CloudFormation
    - 3.3. The app needs to run using free AWS resources (ECS with EC2 t3.micro and Classic Load Balancer)

If you managed to run the application and saw two messages like: `Congratulations` and `The challenge has ended` Your task is complete.

## Bonus tasks

Now, if you want to go further, we've prepared a bonus task. At this point you already have the database connection URL.

Each test taker has a username/password/database in the following MongoDB: `SG-meteor-prod-hiring-59080.servers.mongodirector.com` The username is the first `7 letters` of your email and the password is `meteorhiringdevops`, The database too and the first 7 letters of your email.

I would like your application that you just started on AWS to use your Database.

The task is to migrate `MongoDB` data from one server to another using yours users. If the migration is successful the new database will contain `55,002` records. Now you can also write something in the application and click send and see if your record appears in the values.

## Delivering your solution
The task must be sent by email upon completion, ideally with the repository link and the App URL.

## Tips

1. Explore mongodb connections options with TLS/SSL to connect in server.
2. The password is in base64 format, decrypt it.
3. MongoDB from the bonus task doesn't need the ReplicaSet parameter.
4. This challenge has been tested multiple times, if you get an error it's probably something you didn't do.

- If in doubt, send an email to philippe@meteor.com
- Estimated time to implement the challenge: from `4` to `6` hours

## Evaluation

Assignment delivery will be assessed based on the candidate's abilities to
1. Apply Docker/Terraform best practices
2. Delivery time
3. Bonus Task
