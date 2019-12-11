#!/bin/bash

aws-vault exec appsvcs-voice-admin -- kubeseal -o yaml < secret.yaml.encrypted > secret.yaml
