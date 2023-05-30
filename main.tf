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

# install cert manager and create an issuer
module "cert_manager" {
  source        = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email                   = var.issuer_email
  cluster_issuer_name                    = local.issuer
  cluster_issuer_private_key_secret_name = "cert-manager-${var.name}-private-key"
}

# deploy nginx ingress controller
module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/helm"

  create_namespace = true
  controller_kind = "Deployment"
  namespace = "nginx-ingress"
  define_nodePorts = false

  additional_set = []
}

# setup OIDC provider + application in authentik
module "authentik" {
  source = "./modules/authentik"
  
  name = var.name
  client_id = var.oidc_id
  redirect_uris = ["https://${var.name}.${var.domain}/hub/oauth_callback"]
  authentication_flow = var.authentication_flow
  authorization_flow = var.authorization_flow
}

# deploy z2jh
module "jupyterhub" {
  source = "./modules/jupyterhub"

  name = var.name
  domain = var.domain
  issuer = local.issuer
  oidc_id = var.oidc_id
  oidc_secret = module.authentik.oidc_secret
  logout_url = "${var.authentik_url}/application/o/${var.name}/end-session/"
  authorize_url      = "${var.authentik_url}/application/o/authorize/"
  token_url          = "${var.authentik_url}/application/o/token/"
  userdata_url       = "${var.authentik_url}/application/o/userinfo/"
  login_service      = "JHaaS user management"

  depends_on = [
    kubernetes_namespace.jhaas,
    module.cert_manager,
    module.nginx-controller
  ]
}