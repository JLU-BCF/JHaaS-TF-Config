# create OIDC provider and appliation for filebrowser

data "authentik_flow" "authentication_flow" {
  slug = var.authentication_flow
}

data "authentik_flow" "authorization_flow" {
  slug = var.authorization_flow
}

data "authentik_flow" "invalidation_flow" {
  slug = var.invalidation_flow
}

data "authentik_group" "admins" {
  name = "admins"
}

# data "authentik_user" "leader" {
#   # username needed!
#   username = ""
# }

data "authentik_property_mapping_provider_scope" "default_oidc_mappings" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-profile"
  ]
}

resource "authentik_provider_oauth2" "oidc_provider" {
  name = var.filebrowser_name
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = var.filebrowser_redirect_uri
    }
  ]
  authorization_flow  = data.authentik_flow.authorization_flow.id
  authentication_flow = data.authentik_flow.authentication_flow.id
  invalidation_flow   = data.authentik_flow.invalidation_flow.id
  client_id           = var.filebrowser_oidc_client
  sub_mode            = "user_uuid"

  # use standard oidc mappers
  property_mappings = data.authentik_property_mapping_provider_scope.default_oidc_mappings.ids
}

resource "authentik_application" "application" {
  name              = var.filebrowser_display_name
  slug              = var.filebrowser_name
  protocol_provider = authentik_provider_oauth2.oidc_provider.id
  group             = var.filebrowser_group_name
  meta_description  = var.filebrowser_description
  meta_publisher    = var.filebrowser_hostname
  meta_launch_url   = "https://${var.filebrowser_hostname}/"
}

# resource "authentik_policy_binding" "leader_user_binding" {
#   order = 0
#   target = authentik_application.application.uuid
#   user = data.authentik_user.leader.id
# }

resource "authentik_policy_binding" "admin_group_binding" {
  order  = 10
  target = authentik_application.application.uuid
  group  = data.authentik_group.admins.id
}
