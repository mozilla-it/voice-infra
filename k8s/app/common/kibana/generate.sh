#!/bin/bash

helm template kibana elastic/kibana --no-hooks --version 7.5.0 --values values.yaml | grep -Ev ' *namespace:' | sed -e's/kibana-kibana/kibana/g' > resources.yaml