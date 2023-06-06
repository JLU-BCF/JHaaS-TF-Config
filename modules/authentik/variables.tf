variable "name" {
    description = "name for the OIDC provider"
    type = string
}

variable "redirect_uris" {
    description = "List of valid redirection URLs for cliet"
    type = list(string)
}

variable "client_id" {
    description = "OIDC client id for provider"
}

variable "authentication_flow" {
    description = "slug name of the authentication workflow to use"
    default = "default-authentication-flow"
}

variable "authorization_flow" {
    description = "slug name of the authorization workflow to use"
    default = "default-provider-authorization-implicit-consent"
}
