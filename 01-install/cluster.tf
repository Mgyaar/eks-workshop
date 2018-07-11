resource "aws_eks_cluster" "kubernetes" {
  name     = "${lookup(var.name, terraform.workspace)}"
  role_arn = "${aws_iam_role.kubernetes_role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.kubernetes.id}"]
    subnet_ids         = ["${aws_subnet.public-subnet.*.id}"]
  }
}

resource "aws_iam_role" "kubernetes_role" {
  name = "${lookup(var.name, terraform.workspace)}KubernetesRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kubernetes_cluster_policy" {
  role       = "${aws_iam_role.kubernetes_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "kubernetes_service_policy" {
  role       = "${aws_iam_role.kubernetes_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_key_pair" "sshkey" {
  key_name   = "kubernetes"
  public_key = "${lookup(var.sshkey, terraform.workspace)}"
}

resource "aws_cloudformation_stack" "eks_worker_nodes" {
  name = "${aws_eks_cluster.kubernetes.name}Workers"

  template_url = "https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml"

  parameters {
    ClusterName                      = "${aws_eks_cluster.kubernetes.name}"
    ClusterControlPlaneSecurityGroup = "${aws_security_group.kubernetes.id}"
    NodeGroupName                    = "${aws_eks_cluster.kubernetes.name}-workers"
    NodeAutoScalingGroupMinSize      = 1
    NodeAutoScalingGroupMaxSize      = 1
    NodeInstanceType                 = "m5.large"
    NodeImageId                      = "ami-dea4d5a1"
    Subnets                          = "${aws_subnet.public-subnet.0.id}"
    VpcId                            = "${aws_vpc.kubernetes.id}"
    KeyName                          = "${aws_key_pair.sshkey.key_name}"
  }

  capabilities = ["CAPABILITY_IAM"]
}
