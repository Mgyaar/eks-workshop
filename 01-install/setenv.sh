#!/usr/bin/env bash

set -e

export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-"us-east-1"}
export CLUSTER=${CLUSTER:-princess}

# Step 1 - Install and configure heptio-authenticator-aws in $HOME/bin
export VERSION=0.3.0
cd "$HOME/bin"
curl -L -o heptio-authenticator-aws \
  https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v$VERSION/heptio-authenticator-aws_${VERSION}_linux_amd64

cat >"$HOME/.kube/config" <<EOF
apiVersion: v1
clusters:
- cluster:
    server: $(aws eks describe-cluster --name "$CLUSTER" --query cluster.endpoint)
    certificate-authority-data: $(aws eks describe-cluster --name "$CLUSTER" --query cluster.certificateAuthority.data)
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "$CLUSTER"
EOF
