resource "aws_security_group" "loadbalancer" {
  name        = "${data.terraform_remote_state.eks.cluster}-loadbalancer"
  description = "Allow Kubernetes Access"
  vpc_id      = "${data.terraform_remote_state.eks.vpc}"

  egress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "worker-node-ingress-cluster" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port         = 1025
  protocol          = "tcp"
  security_group_id = "${data.terraform_remote_state.eks.worker-securitygroup}"

  source_security_group_id = "${aws_security_group.loadbalancer.id}"
  to_port                  = 65535
  type                     = "ingress"
}
