terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33.0"
    }
  }
}

variable "secret_namespace" {
  description = "Namespace where main s3 data secret is stored"
}
variable "secret_name" {
  description = "Name of s3 data secret data is stored"
}
variable "name" {
  description = "DNS Name of the JupyterHub"
}

locals {
  k8s_namespace = "jhaas-${var.name}"
}

data "kubernetes_secret" "s3_data_main" {
  metadata {
    namespace = var.secret_namespace
    name      = var.secret_name
  }
}

resource "kubernetes_secret" "s3_data_replica" {

  depends_on = [data.kubernetes_secret.s3_data_main]

  metadata {
    namespace = local.k8s_namespace
    name      = var.secret_name
  }

  data = {
    accessKeyID     = data.kubernetes_secret.s3_data_main.data["access_key"]
    secretAccessKey = data.kubernetes_secret.s3_data_main.data["secret_key"]
  }
}

resource "kubernetes_manifest" "s3_data_dataset_ro" {

  depends_on = [kubernetes_secret.s3_data_replica]

  manifest = {
    apiVersion = "datashim.io/v1alpha1"
    kind       = "Dataset"
    metadata = {
      namespace = local.k8s_namespace
      name      = "shared-ro-${var.name}"
    }
    spec = {
      local = {
        bucket      = "ro-${var.name}"
        provision   = "true"
        readonly    = "true"
        endpoint    = "${data.kubernetes_secret.s3_data_main.data["ssl"] == "true" ? "https" : "http"}://${data.kubernetes_secret.s3_data_main.data["host"]}:${data.kubernetes_secret.s3_data_main.data["port"]}"
        secret-name = var.secret_name
        type        = "COS"
      }
    }
  }
}

resource "kubernetes_manifest" "s3_data_dataset_rw" {

  depends_on = [kubernetes_secret.s3_data_replica]

  manifest = {
    apiVersion = "datashim.io/v1alpha1"
    kind       = "Dataset"
    metadata = {
      namespace = local.k8s_namespace
      name      = "shared-rw-${var.name}"
    }
    spec = {
      local = {
        bucket      = "rw-${var.name}"
        provision   = "true"
        readonly    = "false"
        endpoint    = "${data.kubernetes_secret.s3_data_main.data["ssl"] == "true" ? "https" : "http"}://${data.kubernetes_secret.s3_data_main.data["host"]}:${data.kubernetes_secret.s3_data_main.data["port"]}"
        secret-name = var.secret_name
        type        = "COS"
      }
    }
  }
}