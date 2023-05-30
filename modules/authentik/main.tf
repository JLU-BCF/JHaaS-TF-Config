# create OIDC provider and appliation

data "authentik_flow" "authentication_flow" {
  slug = var.authentication_flow
}

data "authentik_flow" "authorization_flow" {
  slug = var.authorization_flow
}

data "authentik_scope_mapping" "default_oidc_mappings" {
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
    client_id = var.client_id

    # use standard oidc mappers
    property_mappings = data.authentik_scope_mapping.default_oidc_mappings.ids
}

resource "authentik_application" "application" {
  name              = var.name
  slug              = var.name
  protocol_provider = authentik_provider_oauth2.oidc_provider.id
}