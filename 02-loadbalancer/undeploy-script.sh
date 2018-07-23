#!/usr/bin/env bash

kubectl delete -n echoserver ing/echoserver

kubectl delete -f echoserver.yaml
