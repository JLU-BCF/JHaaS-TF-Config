# main jhaas control file

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

# manage namespace explictly, this will allow removal of 
# all depending objects on destroy
resource "kubernetes_namespace" "jhass" {
  metadata {
    name = local.k8s_namespace
  }
}

# deploy z2jh
module "jupyterhub" {
  source = "./modules/jupyterhub"

  name = var.name

  depends_on = [
    kubernetes_namespace.jhass
  ]
}