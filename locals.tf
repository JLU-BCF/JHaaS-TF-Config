locals {
  k8s_namespace = "jhaas-${var.name}"
  jh_hostname   = "${var.name}.${var.domain}"
}
