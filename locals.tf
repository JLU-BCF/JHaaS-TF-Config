locals {
  k8s_namespace = "jhaas-${var.name}"
  issuer = "cert-manager-${var.name}"
}