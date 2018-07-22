#!/usr/bin/env bash

# Step 1 - Get the environment variables

if [[ -z "$K8S_DOMAIN" ]]; then 
   echo "K8S_DOMAIN is empty; set the variable to the domain you are managing..."
   exit 1
fi

echo "Your cluster will manage K8S_DOMAIN=${K8S_DOMAIN}..."

K8S_CLUSTER="$(terraform output cluster)"
K8S_REGION="$(terraform output region)"
K8S_SECURITYGROUP="$(terraform output securitygroup)"
K8S_SUBNET="$(terraform output subnet | tr -d '\n')"
export K8S_CLUSTER K8S_REGION K8S_SECURITYGROUP K8S_SUBNET

# Step 2 - Undeploy the application

envsubst < "ingress.yaml" | kubectl delete -f -

kubectl delete -f echoserver.yaml
