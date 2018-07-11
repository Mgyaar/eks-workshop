# Elastic Kubernetes Service with tools

This repository contains a full setup of AWS Elastic Kubernetes Service as
well as some associated tools, including Spinnaker and Jenkins. In order to
work and since the availability of EKS remains limited, we've assumed a few
things to deploy the project:

- The `aws` command line interface is already installed and configured
- The `$HOME/.aws/credentials` has been populated with your keys in default
- The deployment region is `us-east-1`
- `$HOME/bin` exists and is part of the PATH environment variables
- `kubectl` is installed, part of PATH and must be 1.10+
- `terraform` 0.11.7+ is installed and configured

This workshop goes into some details about a few things, including:

- How to configure and deploy EKS
- How to install Spinnaker
- How to install Jenkins
