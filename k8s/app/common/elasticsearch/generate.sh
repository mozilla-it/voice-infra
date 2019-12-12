#!/bin/bash

helm template elasticsearch elastic/elasticsearch --no-hooks --version 7.5.0 --values values.yaml | grep -Ev ' *namespace:' > resources.yaml
