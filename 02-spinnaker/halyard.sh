#!/usr/bin/env bash

set -e

docker run -p 8084:8084 -p 9000:9000 \
    --name halyard --rm \
    -v $HOME/.hal:/home/spinnaker/.hal \
    -it gcr.io/spinnaker-marketplace/halyard:stable
