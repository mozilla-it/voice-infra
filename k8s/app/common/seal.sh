#!/bin/bash

DIR=$(dirname "$0")
NAMESPACE=$(yq r - namespace < "$DIR/kustomization.yaml")

aws-vault exec appsvcs-voice-admin -- kubeseal --namespace "$NAMESPACE" -o yaml < secret.yaml.encrypted > secret.yaml
