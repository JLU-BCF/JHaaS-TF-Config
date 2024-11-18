# create OIDC provider and appliation

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

data "authentik_property_mapping_provider_scope" "default_oidc_mappings" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-profile"
  ]
}

resource "authentik_provider_oauth2" "oidc_provider" {
    name = var.name
    redirect_uris = var.redirect_uris
    authorization_flow = data.authentik_flow.authorization_flow.id
    authentication_flow = data.authentik_flow.authentication_flow.id
    invalidation_flow = data.authentik_flow.invalidation_flow.id
    client_id = var.client_id
    sub_mode = "user_uuid"

    # use standard oidc mappers
    property_mappings = data.authentik_property_mapping_provider_scope.default_oidc_mappings.ids
}

resource "authentik_application" "application" {
  name              = var.jh_display_name
  slug              = var.name
  protocol_provider = authentik_provider_oauth2.oidc_provider.id
  group             = local.group_name
  meta_description  = var.jh_description
  meta_icon         = var.jh_icon
  meta_publisher    = var.jh_hostname
  meta_launch_url   = "https://${var.jh_hostname}/"
}

resource "authentik_policy_binding" "group_binding" {
  order             = 0
  target            = authentik_application.application.uuid
  group             = var.authentik_jh_group_id
}

resource "authentik_policy_binding" "admin_group_binding" {
  order             = 10
  target            = authentik_application.application.uuid
  group             = data.authentik_group.admins.id
}
