output "oidc_secret" {
  value = authentik_provider_oauth2.oidc_provider.client_secret
}