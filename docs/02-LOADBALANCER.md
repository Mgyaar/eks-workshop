# Loadbalancer and DNS integration

There are several ways to connect your EKS cluster to the outside. One is to
use the `alb-ingress-controller` that has been given to the Kubernetes SIGs
and which registers URL into an ALB based upon a set of metadata defined in
the Ingress. The 
[setup](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/docs/setup.md)
document explains how to install it. 

This stack does the associated installation; it requires:

- You run `terraform apply` that adds the required permissions to the worker,
  creates a security group and provide a way for the securiy group from the
  worker to be accessed from the ALB. It also creates output so that the
  script can interpolate the required variables
- Before you continue, you must set the K8S_DOMAIN variable with the domain
  you want your environment to manage. Make sure the associated zone is
  part of the same AWS account. For instance, run
  `export K8S_DOMAIN=example.com`
- You could configure the environment with the Ingress Controller and with
  the External DNS Controller. The `deploy-script.sh` does it and deploy an
  example so that you should be able to access a web server from the
  `echo.example.com` URL.

> Note: `deploy-script.sh` requires `envsubst` to be installed to work as
  expected
