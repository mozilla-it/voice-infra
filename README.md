# voice-infra
This repository contains the infrastructure code for running voice.mozilla.org

# Table of content

 - 1 [FAQ](#fac)
 - 2 [User Management](#user-management)
 - 3 [Infrastructure: Terraform](#terraform)
 - 4 [Dependencies](#dependencies)
 - 5 [Secrets](#secrets)
 - 6 [CI/CD](#ci-cd)
 - 7 [Metrics, Logs and Alerts](#metrics-logs-alerts)


# FAQ
This section contains frequently asked questions with a short answer, read the complete README for longer explanation about these topics.

### What is the AWS account where Voice lives?
Voice lives in appsvcs-voice AWS account. Right now Stage is deployed into an EKS cluster and prod into a series of EC2 instances managed by Nubis.

### How can I see when the application was deployed for last time?

### How can I trigger a deployment of the application?

### How can I get into the Kubernetes cluster?
`aws eks update-kubeconfig --name voice`. That will get a kubeconfig for you, now you can run kubectl commands.

### Where can I see how the (healthy) status of Voice?

### How can I restart the application?


# User management
This section describes how to create new users (intented for developers) in AWS and how can they connect to the Kubernetes cluster.
In order connect to the cluster, a user must have installed the next dependencies:
 - awscli >= 1.16.154
 - kubectl >= 1.13 

### Creating a user in AWS
AWS users are managed using Terraform. In order to create a new user, one has to edit the file `t7m/users.tf`. Copy the resources used by the user `alberto`, change the name of the new user and run `terraform apply` to apply the changes.

Once Terraform finishes, it should have created a set of credentials which will allow the user to visit the AWS Console. These credentials can be obtained running `terraform output password_username`, the output is a base64 blob containing the GPG encoded password. Now, give the credentials to the new user, she can decrypt the password running: `cat terraform_ouput_pw | base64 -d | keybase gpg decrypt`.

### Grant access to the Kubernetes cluster
Once the user has a AWS IAM user created, and it can assume the "developers" role, it's time to configure the environment:
 1. Export your AWS keys as environment variables: `export AWS_ACCESS_KEY_ID=... && export AWS_SECRET_ACCESS_KEY=...`
 2. Get the EKS cluster configuration: `aws eks update-kubeconfig --name voice --role-arn arn:aws:iam::058419420086:role/developers`
 3. That's it! Verify your access running `kubectl get pods -n=voice-stage`

# Infrastructure: Terraform



# Dependencies
This section aims to list the different resources needed to build, deploy and run Voice.

### Application dependencies
 - MySQL: primary database
 - Redis: caching layer
 - S3: stores user submitted clips (mainly)
 - Elasticsearch: using the Kibana visualizations, privileged users can see various metrics.

### Other AWS resources needed
 - Route53 domains
 - Users
 - IAM roles to make all components work together.

### Code and configuration repositories:
 - [Voice](https://github.com/mozilla/voice-web) Repository containign the code of the Common Voice web application
 - [Voice Infra](https://github.com/mozilla-it/voice-infra) This repo. Terraform code, Kubernetes manifests for infrastructure components and docs used for sysadmins/operators to create and manage Discourse installations.

# Secrets


# Application build and deploy: CI/CD

### Build

### Deploy into Kubernetes


# Metrics, Logs and Alerts

## Metrics

## Logs

## Alerts
