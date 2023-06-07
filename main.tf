# main jhaas control file

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

provider "kubectl" {
  config_path = var.kubeconfig
}

provider "authentik" {
  url = var.authentik_url
  token = var.authentik_token
}

# manage namespace explictly, this will allow removal of
# all depending objects on destroy
resource "kubernetes_namespace" "jhaas" {
  metadata {
    name = local.k8s_namespace
  }
}

# setup OIDC provider + application in authentik
module "authentik" {
  source  = "./modules/authentik"

  name          = var.name
  client_id     = var.oidc_id
  redirect_uris = ["https://${var.name}.${var.domain}/hub/oauth_callback"]

  authentication_flow     = var.authentication_flow
  authorization_flow      = var.authorization_flow
  authentik_jh_group_id   = var.authentik_jh_group_id
  jh_display_name         = var.jh_display_name
  jh_description          = var.jh_description
  jh_icon                 = var.jh_icon
  jh_hostname             = local.jh_hostname
}

# deploy z2jh
module "jupyterhub" {
  source = "./modules/jupyterhub"

  name        = var.name
  domain      = var.domain
  issuer      = var.issuer
  oidc_id     = var.oidc_id
  oidc_secret = module.authentik.oidc_secret
  logout_url              = "${var.authentik_url}/application/o/${var.name}/end-session/"
  authorize_url           = "${var.authentik_url}/application/o/authorize/"
  token_url               = "${var.authentik_url}/application/o/token/"
  userdata_url            = "${var.authentik_url}/application/o/userinfo/"
  login_service           = "JHaaS user management"
  jupyter_notebook_image  = var.jupyter_notebook_image

  depends_on = [
    kubernetes_namespace.jhaas,
  ]
}
