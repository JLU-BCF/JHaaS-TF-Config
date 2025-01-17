# main jhaas control file

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

provider "authentik" {
  url   = var.authentik_url
  token = var.authentik_token
}

# manage namespace explictly, this will allow removal of
# all depending objects on destroy
resource "kubernetes_namespace" "jhaas" {
  metadata {
    name = local.k8s_namespace
  }
}

resource "kubernetes_resource_quota" "jhaas" {
  depends_on = [kubernetes_namespace.jhaas]

  count = var.apply_ns_resource_quota ? 1 : 0

  metadata {
    name      = "${local.k8s_namespace}-quota"
    namespace = local.k8s_namespace
  }

  spec {
    hard = {
      cpu    = var.ns_cpu_limit,
      memory = var.ns_ram_limit
    }
  }
}

# setup OIDC provider + application in authentik
module "authentik" {
  source = "./modules/authentik"

  depends_on = [kubernetes_namespace.jhaas]

  name         = var.name
  client_id    = var.oidc_id
  redirect_uri = "https://${var.name}.${var.domain}/hub/oauth_callback"

  authentication_flow   = var.authentication_flow
  authorization_flow    = var.authorization_flow
  invalidation_flow     = var.invalidation_flow
  authentik_jh_group_id = var.authentik_jh_group_id
  jh_display_name       = var.jh_display_name
  jh_description        = var.jh_description
  jh_icon               = var.jh_icon
  jh_hostname           = local.jh_hostname
}

module "datashim" {
  source = "./modules/datashim"

  depends_on = [kubernetes_namespace.jhaas]

  name             = var.name
  secret_namespace = var.secret_namespace
  secret_name      = var.secret_name
}

# deploy z2jh
module "jupyterhub" {
  source = "./modules/jupyterhub"

  depends_on = [module.authentik, module.datashim]

  helm_chart_version = var.jh_chart_version
  name               = var.name
  domain             = var.domain
  issuer             = var.issuer
  oidc_id            = var.oidc_id
  oidc_secret        = module.authentik.oidc_secret
  logout_url         = "${var.authentik_url}/application/o/${var.name}/end-session/"
  authorize_url      = "${var.authentik_url}/application/o/authorize/"
  token_url          = "${var.authentik_url}/application/o/token/"
  userdata_url       = "${var.authentik_url}/application/o/userinfo/"
  login_service      = "JHaaS user management"

  jh_admin_id = var.jh_admin_id

  nb_count_limit     = var.nb_count_limit
  nb_home_size       = var.nb_home_size
  nb_home_mount_path = var.nb_home_mount_path
  nb_ram_guarantee   = var.nb_ram_guarantee
  nb_cpu_guarantee   = var.nb_cpu_guarantee
  nb_ram_limit       = var.nb_ram_limit
  nb_cpu_limit       = var.nb_cpu_limit

  jupyter_notebook_image       = var.jupyter_notebook_image
  jupyter_notebook_default_url = var.jupyter_notebook_default_url

  jh_placeholder_replicas   = var.jh_placeholder_replicas
  jh_concurrent_spawn_limit = var.jh_concurrent_spawn_limit
  nb_start_timeout          = var.nb_start_timeout

  service_portal_api_token = var.jh_api_token
}
