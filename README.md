# Elastic Kubernetes Service and tools

This repository contains a setup of AWS Elastic Kubernetes Service as
well as some associated tools. The availability of EKS remains limited for
now and we can assume a lot of things will change in the future. Do not
hesitate to open an issue or correct the project if you find anything wrong.

## Before you start

This project assumes a few pre-requisites:

- The `aws` command line interface must be installed and configured
- The `$HOME/.aws/credentials` should contain a valid access/secret key in
  the `default` section
- The deployment region is `us-east-1`
- `$HOME/bin` exists and is part of the PATH environment variables
- `kubectl` is installed, part of PATH and must be 1.10+
- `terraform` 0.11.7+ is installed and configured
- `bash` scripts can be used and have access to `awk`, `curl`, `terraform`
  `kubectl`, `jq`, `envsubst` via `gettext`, `tr`...

## Steps

This workshop goes into some details about a few things, including:

- [How to configure and deploy EKS](docs/01-INSTALL.md)
- [How to configure the ALB Ingress Controller and External DNS](docs/02-LOADBALANCER.md)
