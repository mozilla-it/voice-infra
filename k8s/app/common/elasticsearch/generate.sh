#!/bin/bash

helm template elasticsearch elastic/elasticsearch --dry-run --values values.yaml | grep -Ev ' *namespace:' > resources.yaml
