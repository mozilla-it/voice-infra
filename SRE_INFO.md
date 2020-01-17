# SRE Info

## Voice Production overview
The application lives in the `appsvcs-voice` AWS account. Currently, the production site is running in "Nubis", this means that it's running as an old school application running in EC2 instances.
Stage is running in Kubernetes (EKS) inside the same account, all the documentation above talks about the current production deployment in Nubis. 

The configuration of the different components it's done via Puppet, see the code [here](https://github.com/mozilla/voice-web/tree/master/nubis/puppet)
The infrastructure components are created using Terraform, see the code [here](https://github.com/mozilla/voice-web/tree/master/nubis/terraform)
As part of the Nubis bundle, there is a web interface which can be used to see recent deployments (Jenkins), metrics (Prometheus + Grafana), to login in the AWS account, to see the application logs (Kibana), and few other things. This is behing SSO and can be reached [here](https://sso.core.us-west-2.appsvcs-voice.nubis.allizom.org/)

There are 3 different types of VMs used by Voice, each one with a different purpose: 
 - webserver: multiple instances, runs the Voice NodeJS application. Part of an AWS autoscaling group.
 - db-monitor-mysql: allows to query the database.
 - sync: runs a daemon which syncs some of the data stored in the MySQL database to Elasticsearch. That info later displayed in a Kibana instance inside Voice. Only used internally.

## Infra Access
 - AWS account: `aws-vault login appsvcs-voice-admin'.
 - Nubis dashboard: https://sso.core.us-west-2.appsvcs-voice.nubis.allizom.org/
 - SSH access: first ssh into the jumphost (jumphost.core.us-west-2.appsvcs-voice.nubis.allizom.org) forwarding your key (-A) and using your LDAP username, from there jump to the server you want to inspect.

## Source Repos
Infrastructure repo (this repo) [voice-infra](https://github.com/mozilla-it/voice-infra)
Voice application code: [voice-web](https://github.com/mozilla/voice-web)

## Monitoring
[Grafana External Metrics](https://biff-5adb6e55.influxcloud.net/d/i4bXkqAZz/voice?orgId=1)
[Grafana Nubis Metrics](https://sso.core.us-west-2.appsvcs-voice.nubis.allizom.org/) Click on "Graphs" in the top menu.
[Application Logs](https://sso.core.us-west-2.appsvcs-voice.nubis.allizom.org/) Click on "Logs" in the top menu.
[New Relic Ping Test](https://synthetics.newrelic.com/accounts/2239138/monitors/1737b03d-e9a3-4ad8-aba1-cf5ee20b6f80)
[New Relic APM](https://rpm.newrelic.com/accounts/2518279/applications)

## Deployment
Deployment it's done via Jenkins. The UI can be accessed via the Nubis dashboard, clicking on ["Pipeline"](https://sso.core.us-west-2.appsvcs-voice.nubis.allizom.org/) in the top-left. There one can see when was the last deployment, trigger a new one, status, etc...

## Alerts
Currently, we only have alerts coming from New Relic Synthetics which will inform us if the site is down. These alerts go to #it-sre-alerts and are hooked up to PagerDuty.

## SSL Certificates
All the SSL certificates used by Voice are issued by AWS ACM, and their expiration is checked via sre-metrics-collector.

## Cloud Account
The AWS account is `appsvcs-voice` with ID `1579256089960917161`.

## Playbooks

### Kibana doesn't have data.
Sometimes stakeholders of the Voice project can contact us letting us know that "Kibana doesn't have data" or "Kibana has stopped synching". This happens because the daemon running in the "sync" server dies/blocks silently, not letting systemd restarting it.
This only has internal impact, and once the process is started, it will catch up with the missed data.
In oder to fix it, just restart the sync server. It's the fastest choice. It can happen that after starting, the sync daemon uses all the available resources, freezing the server and making it miss some health checks. In this case it will be restarted but chatch up eventually.

As a part of the migration to Kubernetes, we will make this process more stable

### We expect a big increase in the traffic.
The application, from the infrastructure point of view, should be able to scale the number of webservers automatically. However it's always good to prepare checking the current load of the database (which seems to be a bottleneck) and increasing the instance size if required.

### The site is down
First, log into the Nubis dashboard and check if a new deployment was recently done. Talk to the devs in that case.
Check that there are webservers available and check the load in those. You can use AWS console for this.
Check how the database is doing in terms of load.
Finally, check Kibana logs trying to find error messages.

## Contacts
 - Voice development channel is #commonvoiceinternal in Slack.
 - Voice public channel is #common-voice in Slack.
 - The 3 people currently developing the site are: @jz/phire, @rshaw and @nemo
