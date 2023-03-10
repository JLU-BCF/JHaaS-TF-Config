resource "helm_release" "jupyterhub" {
  chart            = "jupyterhub"
  name             = "jupyterhub"
  namespace        = local.k8s_namespace
  create_namespace = true
  repository       = "https://jupyterhub.github.io/helm-chart/"
  version          = var.helm_chart_version
  wait             = true

  # define spawner resource limits and image
  values = [yamlencode(
    { 
      singleuser = {
        image = {
          name = local.jupyter_notebook_image_name,
          tag = local.jupyter_notebook_image_tag == "" ? "latest" : local.jupyter_notebook_image_tag
        },
        memory = {
          limit = var.spawner_memory_limit,
          guarantee =var.spawner_memory_limit
        },
        cpu = {
          limit = tonumber(var.spawner_cpu_share),
          guarantee = tonumber(var.spawner_cpu_share)
        }
      }
    }
  )]

  # size of the notebook home director volume
  set {
    name = "singleuser.storage.capacity"
    value = var.home_directory_size
  }
}


