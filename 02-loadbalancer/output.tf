output region {
  value = "${data.terraform_remote_state.eks.region}"
}

output cluster {
  value = "${data.terraform_remote_state.eks.cluster}"
}

output "securitygroup" {
  value = "${aws_security_group.loadbalancer.id}"
}

output "subnet" {
  value = "${data.terraform_remote_state.eks.subnet}"
}
