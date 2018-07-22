# Installing EKS

Assuming you've configured all the requirements as described in the
`README.md` file and your default access and secret keys are well
defined, intalling the EKS cluster should be as simple as moving
into the 01-install directory and running `terraform apply`. Once
done, you would need:

- To source `setenv.sh` by running `. ./setenv.sh`. It would install
  the heptio adapter for AWS IAM and create the config file
- To run the `update.sh` script that allows the workers to join and
  install the monitoring tools.

The directory also contains a scripts `get-token.sh` that gets a
token to connect to the console and displays the associated URL.

> Note: this installation is built for the most part from the 
  [Getting Started with AWS EKS](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html). 
  The main difference is that the kubernetes workers are 
  remain in a private set of subnets.
