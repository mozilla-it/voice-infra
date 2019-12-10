#!/bin/bash

helm template redis stable/redis --dry-run --values values.yaml  > redis.yaml
