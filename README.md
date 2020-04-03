# voice-infra
This repository contains the infrastructure code for running voice.mozilla.org

# Table of content

 - [Environments](#environments)
 - [FAQ](#faq)
 - [Application deployment: CI/CD](#application-deployment-ci-and-cd)
 - [Monitoring](#monitoring)
 - [User Management](#user-management)
 - [Secrets](#secrets)
 - [Dependencies](#dependencies)

# Environments
Voice is deployed in 4 different environments: Production (prod), Stage (stage), Development (dev), and Sandbox (sandbox).
All of them are deployed in the same Kubernetes cluster using different namespaces. 
Here it's a summary of the environments, URLs and deployment method:

| Env        | URL                               | Deployment                                    |
|------------|-----------------------------------|-----------------------------------------------|
| Production | https://voice.mozilla.org         | Manual                                        |
| Stage      | https://stage.voice.mozit.cloud   | Merge to `stage` branch or tag with `stage-v*`|
| Dev        | https://dev.voice.mozit.cloud     | Merge to `master` branch                      |
| Sandbox    | https://sandbox.voice.mozit.cloud | Manual                                        |


# FAQ
This section contains frequently asked questions with a short answer, read the complete README for longer explanation about these topics.

### What is the AWS account where Voice lives?
Voice lives in appsvcs-voice AWS account. Right now Stage is deployed into an EKS cluster and prod into a series of EC2 instances managed by Nubis.

### How can I see when the application was deployed for last time?
For `dev` or `stage` environments, where the deployment is happening automatically, you can check #voice-monitoring Slack looking for Flux notifications. 
You can also look at the chart for the specified environment, there should be commits by Flux specifying the commit hash of the voice-web commit which was deployed.

For Production and Sandbox environment, the easiest way to see when the application was deployed for last time is to check the age of the pods. For example for prod
we run `kubectl get po -l=app=voice -n=voice-prod`, the output will show how old are the pods and from there we can figure out when it was deployed

### How can I trigger a deployment of the application?
Triggering a new deployment of the application is different per environments. Refer to the [Environments](#Environments) section for more information

### How can I get into the Kubernetes cluster?
`aws eks update-kubeconfig --name voice-prod`. That will get a kubeconfig for you, now you can run kubectl commands.

### Where can I see how the (healthy) status of Voice?
As a user, the best option is to visit the site https://voice.mozilla.org
As a developer or administrator, you have several options:
 - Check the status of your pods
 - Check logs in Papertrail
 - Check Slack #voice-monitoring for alerts
 - Check New Relic Synthetics [voice monitor](https://synthetics.newrelic.com/accounts/2239138/monitors/1737b03d-e9a3-4ad8-aba1-cf5ee20b6f80) status

### How can I restart the application?
Restarting the application can be done killing all the running pods and letting Kubernetes spawn a new ones.
Generarily you can perform a rolling restart issuing: `kubectl rollout restart deployment/voice-dev`. Substitute `voice-dev` with the correct environment.


# Application Deployment CI and CD
The deployment pipeline created has 2 clearly differentiated steps: building a container with the new code (CI) and deploying images into Kubernetes (CD).
The next two sections explain each process in detail.

## Continuous Integration (CI)
Continuous Integration from voice-web is done via Travis CI. You can read the public Travis script [here](https://github.com/mozilla/voice-web/blob/master/.travis.yml)
The general strategy here is to create container images with tags matching the environment where we want to deploy them. For example tagging a commit with "stage-v" will kick a Travis build, which will result in a new container image tagged `voice-web:stage-vxxx`. Travis runs in each merge to master, production or stage branches.
For more information about the precise tags, please read the Travis script. You can also look at the "Environments" section, for an easier overview.

## Continous Delivery (CD)
Continuous Delivery, or deploying into the cluster, is done by FluxCD using Helm Releases.
For each of the 4 different environments there is a HelmRelease object defining how the environment looks like (number of replicas, external services URLs...) and how it should be deployed I.e: which container images should be deployed into each environment. These HelmRelease objects can be found [here](https://github.com/mozilla-it/voice-infra/tree/master/kubernetes/releases)

FluxCD is watching a Docker registry for new images (Dockerhub in our case), once a new image is available, it will run the tags against the list of HelmReleases, and if some of them match will deploy it. For deploying, FluxCD will commit to this `voice-infra` repository and modify the line specifying which container to run in the matched HelmRelease. After it will mirror it to the cluster (deploy it).

The Helm Chart used is kept separated from this repo, together with other Charts managed by Mozilla IT SE team. Check it [here](https://github.com/mozilla-it/helm-charts/tree/master/charts/mozilla-common-voice)


# Monitoring
This section describes different ways to check the application health and status.

## Application performance
Application performance is being recorded by New Relic using APM feature.

## Logs
Application logs for all environments are forwarded from each application pod to Papertrail where they are retained for a month. Logs there are divided in 4 groups, one per environment. 
Developers and administrators can use Papertrail web application or cli to read these logs.

## Alerts
Voice is being monitored by New Relic Synthetics via [this monitor](https://synthetics.newrelic.com/accounts/2239138/monitors/1737b03d-e9a3-4ad8-aba1-cf5ee20b6f80) status


# User management
## Accessing AWS console
Access to the AWS console is controlled via IAM roles. A user can be granted permissions to browse with Read Only permissions the AWS console adding them to the `voice-dev` LDAP group. From there on, they have to use `maws` tool to get the credentials. `maws` uses Auth0 and Mozilla SSO to achieve passwordless login into AWS.

## Accesing the Kubernetes cluster
Access to the Kubernetes cluster is managed via Roles inside the cluster. The role definition can be found [here](https://github.com/mozilla-it/voice-infra/tree/master/kubernetes/rbac).
In order to configure your system for accessing Kubernetes, first make sure you have `maws`, `aws` and `kubectl` installed in your system. Also as stated in the previous step, you have to be part of the `voice-dev` LDAP group. Now follow the next steps:
1. Run `maws` and select "maws-devs-rw` inside `appsvc-voice` this will authenticate you in the AWS account
2. `aws eks update-kubeconfig --name itse-apps voice-prod`
3. That is all, test your access running `kubectl get pods --namespace voice-dev`


# Secrets
Secrets used by the application are stored in AWS Secret Manager and fetched by the application during start time.
This secrets are manually placed there by a SRE engineer.


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
