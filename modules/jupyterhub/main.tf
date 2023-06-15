resource "helm_release" "jupyterhub" {
  chart            = "jupyterhub"
  name             = "jupyterhub"
  namespace        = local.k8s_namespace
  create_namespace = false
  repository       = "https://jupyterhub.github.io/helm-chart/"
  version          = var.helm_chart_version
  wait             = true

  # define spawner resource limits and image
  values = [yamlencode(
    {
      scheduling = {
        userScheduler = {
          enabled = false
        }
      },
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
      },
      ingress = {
        enabled = true,
        hosts = [local.hostname],
        annotations = {
          "kubernetes.io/tls-acme" = "true",
          "cert-manager.io/cluster-issuer" = var.issuer
        },
        tls = [{
          hosts = [local.hostname],
          secretName: "${var.name}-tls"
        }
        ]
      },
      proxy = {
        service = {
          type = "ClusterIP"
        },
        https = {
          type = "offload"
        }
      },
      hub = {
        config = {
          JupyterHub = {
            authenticator_class = "generic-oauth"
          },
          Authenticator = {
            auto_login = true
          }
          GenericOAuthenticator = {
            client_id           = var.oidc_id,
            client_secret       = var.oidc_secret,
            scope               = ["openid", "profile", "email"],
            admin_groups        = ["admins"],
            allowed_groups      = ["admins", "jh_${var.name}"],
            logout_redirect_url = var.logout_url,
            oauth_callback_url  = "https://${local.hostname}/hub/oauth_callback",
            authorize_url       = var.authorize_url,
            token_url           = var.token_url,
            userdata_url        = var.userdata_url,
            login_service       = var.login_service,
            username_claim      = "sub",
            username_key        = "sub"
          }
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
