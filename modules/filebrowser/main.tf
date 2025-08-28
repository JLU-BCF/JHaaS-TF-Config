resource "helm_release" "filebrowser" {
  name = var.filebrowser_name

  repository = "oci://harbor.computational.bio.uni-giessen.de/jhaas"
  chart      = "filebrowser-quantum"

  version = var.chart_filebrowser_version

  # MUST be deployed in existing jhaas namespace, else pvcs cannot share
  create_namespace = false
  namespace        = var.jhaas_namespace

  values = [yamlencode(
    {
      ingress = {
        enabled     = true
        class       = "nginx"
        host        = var.filebrowser_hostname
        certSecret  = "sec-${var.filebrowser_name}-tls"
        maxBodySize = "100M"
      }

      persistence = {
        enabled      = false
        keep         = false
        storageClass = "cinder-csi"
      }

      extraVolumeMounts = var.extra_volume_mounts
      extraVolumes      = var.extra_volumes

      config = {
        server = {
          disablePreviews              = true
          disablePreviewResize         = true
          disableTypeDetectionByHeader = true
          sources                      = var.volume_sources
        }

        auth = {
          methods = {
            password = {
              enabled = false
            }

            oidc = {
              enabled      = true
              clientId     = var.filebrowser_oidc_client
              clientSecret = authentik_provider_oauth2.oidc_provider.client_secret
              issuerUrl    = var.filebrowser_oidc_issuer
              # logoutRedirectUrl = var.filebrowser_oidc_logout_url
              scopes     = "openid email profile"
              createUser = true
              adminGroup = "admins"
            }
          }
        }

        frontend = {
          disableDefaultLinks   = true
          disableUsedPercentage = true
          externalLinks         = []
        }

        userDefaults = {
          viewMode    = "list"
          singleClick = true
          showHidden  = true
          permissions = {
            api    = true
            modify = true
          }
          loginMethod = "oidc"
          fileLoading = {
            maxConcurrentUpload = 10
            uploadChunkSizeMb   = 10
          }
        }
      }
    }
  )]
}
