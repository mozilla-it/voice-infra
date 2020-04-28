# voice-infra
This repository contains the infrastructure code for running voice.mozilla.org

# Table of content

 - [Environments](#environments)
 - [FAQ](#faq)
 - [Application deployment: CI/CD](#application-deployment-ci-and-cd)
 - [Monitoring](#monitoring)
 - [User Management](#user-management)
 - [Application Configuration](#application-configuration)
 - [Secrets](#secrets)
 - [Dependencies](#dependencies)
 - [Database access](#db-access)

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
Restarting the application can be done killing all the running pods and letting Kubernetes spawn new ones.
Generally you can perform a rolling restart issuing: `kubectl rollout restart deployment/voice-dev`. Substitute `voice-dev` with the correct environment.


# Application Deployment CI and CD
The deployment pipeline created has 2 clearly differentiated steps: building a container with the new code (CI) and deploying images into Kubernetes (CD).
The next two sections explain each process in detail.

## Continuous Integration (CI)
Continuous Integration from voice-web is done via Travis CI. You can read the public Travis script [here](https://github.com/mozilla/voice-web/blob/master/.travis.yml)
The general strategy here is to create container images with tags matching the environment where we want to deploy them. For example tagging a commit with "stage-v" will kick a Travis build, which will result in a new container image tagged `voice-web:stage-vxxx`. Travis runs in each merge to master, production or stage branches.
For more information about the precise tags, please read the Travis script. You can also look at the "Environments" section, for an easier overview.

## Continuous Delivery (CD)
Continuous Delivery, or deploying into the cluster, is done by FluxCD using Helm Releases.
For each of the 4 different environments there is a HelmRelease object defining how the environment looks like (number of replicas, external services URLs...) and how it should be deployed I.e: which container images should be deployed into each environment. These HelmRelease objects can be found [here](https://github.com/mozilla-it/voice-infra/tree/master/kubernetes/releases)

FluxCD is watching a Docker registry for new images (Dockerhub in our case), once a new image is available, it will run the tags against the list of HelmReleases, and if some of them match will deploy it. For deploying, FluxCD will commit to this `voice-infra` repository and modify the line specifying which container to run in the matched HelmRelease. After it will mirror it to the cluster (deploy it).

The Helm Chart used is kept separated from this repo, together with other Charts managed by Mozilla IT SE team. Check it [here](https://github.com/mozilla-it/helm-charts/tree/master/charts/mozilla-common-voice)

## Manually deploying
Manually deploying only makes sense for the environments where Continuous Delivery is not set up. If it is, your manuall deploy will be overwritten in less than 5 minutes to reflect the status that Flux has. 
You can verify if Flux is autodeploying for an environment looking at the HelmRelease definition and searching for the annotation `fluxcd.io/automated: "false"`. For example prod environment is an example, check it [here](https://github.com/mozilla-it/voice-infra/blob/master/kubernetes/releases/voice-prod/voice-prod-chart.yaml#L8).

Once you are sure the environment doesn't have automatic deploys enabled, manually deploying is as easy as editing the Kubernetes Deployment object for the right environment. When the editor is open modify the line `container: voice-web/my-tag-xxxx` changing the tag for the container you want to get deployed. After saving and quitting the edit, Kubernetes will start a rolling update of the pods. This is an example command for changing the image in production: `kubectl edit deployment voice-prod -n=voice-prod`.

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

## Accessing the Kubernetes cluster
Access to the Kubernetes cluster is managed via Roles inside the cluster. The role definition can be found [here](https://github.com/mozilla-it/voice-infra/tree/master/kubernetes/rbac).
In order to configure your system for accessing Kubernetes, first make sure you have `maws`, `aws` and `kubectl` installed in your system. Also as stated in the previous step, you have to be part of the `voice-dev` LDAP group. Now follow the next steps:
1. Run `maws` and select "maws-devs-rw` inside `appsvc-voice` this will authenticate you in the AWS account
2. `aws eks update-kubeconfig --name itse-apps voice-prod`
3. That is all, test your access running `kubectl get pods --namespace voice-dev`


# Application configuration
This section describes how to check and modify the Voice configuration. Voice reads its configuration from environment variables which are stored in a Kubernetes ConfigMap object, this object is fully mapped to environment values inside the container

## Checking configuration values
In order to check the values configuring Voice, we need to look at the environment values present in the container which have a `CV_` prefix. Checking variables in the running container makes sure that we get the values which are currently being used. 
The next command will display all the configuration values for voice in the current namespace: `kubectl exec -ti $(kubectl get po -l=app=voice | grep voice- | head -1 | cut -d' ' -f 1) env | grep CV_`. Alternatively you can get a list of pods, exec into one and run the `env` command.

## Adding a new environment variable
Adding a new environment variable can be achieved through 3 different ways, each one designed to fulfill a different use case: adding the value to the Helm Chart, adding the value to the Helm Release or adding the value manually. The next sections explain why would you choose one or the other.

### Add it in the Helm Chart
If the new variable you want to add is a core value which will be used by all the deployments of Voice, the right place to add it is into the mozilla-common-voice Helm Chart here. An example will be a variable representing the database host or the name of the S3 bucket containing the uploaded clips. 
In order to add it, you have to modify the chart [here](https://github.com/mozilla-it/helm-charts/tree/master/charts/mozilla-common-voice) and submit a pull request for merging it. There you will have to edit the file `templates/configmap.yaml` adding the definition of the new variable, add a default value in `values.yaml` and later, increase the version of the chart in `Chart.yaml`.
Once this is done, modify the HelmRelease object for the environment you want. For example for stage you will have to modify [this file](https://github.com/mozilla-it/voice-infra/blob/master/kubernetes/releases/voice-dev/voice-dev-chart.yaml) adding a custom value for the variable, and referencing the chart version that you just bumped. After both changes are merged, the application will be deployed following the rules described in CD section.

### Add it in the HelmRelease object
If the new variable is something intended just for your deployment, the best place to add it is in the section `extra_vars` of the HelmRelease, for dev it will be [here](https://github.com/mozilla-it/voice-infra/blob/master/kubernetes/releases/voice-dev/voice-dev-chart.yaml#L55). Examples of these variables will be a New Relic key and environment, or the address of the central log collector host.
In order to add variables using this method, just add it to the file specified above, and merge it. Flux should autodeploy it following the CD rules.

### Add it manually (will be overwritten)
If the new variable is for testing, you can add it manually to the configmap. But remember that it will be overwritten after a new deploy.
In order to do this, edit the configmap object in the environment where you want to add it. For stage environment you can do it running `kubectl edit configmap voice-config --namespace voice-stage`.

### Reading the value from the application
Now that you have the environment variable in the right place, you have to make sure that Voice, the application, is reading it. For it modify the config-helper file [here](https://github.com/mozilla/voice-web/blob/master/server/src/config-helper.ts) and reference the new variable.

### Restart the application
After adding the variable via one method or the other you have to manually (this might change in the future) restart the application. If the change was deployed by Flux, and there were changes in the application code, this is already done. Refer to "How to restart the application" in the FAQ section for more details.


# Secrets
Secrets used by the application are stored in AWS Secret Manager and fetched by the application during start time.
These secrets are manually placed there by a SRE engineer.


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
 - [Voice](https://github.com/mozilla/voice-web) Repository containing the code of the Common Voice web application
 - [Voice Infra](https://github.com/mozilla-it/voice-infra) This repo. Terraform code, Kubernetes manifests for infrastructure components and docs used for sysadmins/operators to create and manage Discourse installations.


# DB access
The databases used by Voice are created using RDS, inside a VPC without public access. This means that they are not getting a public IP, so in order to talk to them you have to be in the same VPC network.
To bypass this problem without creating a VPN which adds more complexity to the architecture, we decided to create a DB monitor pod in each namespace. The pod has preinstalled mysql and other cli utilities, and it gets the right user and password set in `/etc/my.cnf`.
In order to use access the database, exec into the db monitor pod and run your desired mysql command. You can exec into the db-monitor for stage running the next command `kubectl -n=voice-stage exec -ti $(kubectl get po -n=voice-stage -l=app=db-monitor |  tail -1 | cut -d' ' -f 1) bash`. Change the namespace for connecting to other db-monitor pods.
