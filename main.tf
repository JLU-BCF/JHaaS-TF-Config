# main jhaas control file

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

# deploy z2jh
module "jupyterhub" {
  source = "./modules/jupyterhub"

  name = var.name
}