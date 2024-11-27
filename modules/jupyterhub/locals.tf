locals {
  jupyter_notebook_image_name = split(":", var.jupyter_notebook_image)[0]
  jupyter_notebook_image_tag  = split(":", var.jupyter_notebook_image)[1]
  k8s_namespace               = "jhaas-${var.name}"
  hostname                    = "${var.name}.${var.domain}"
}