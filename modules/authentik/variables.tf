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

variable "authentik_jh_group_id" {
    description = "ID of the group that will be bound to the application"
}

variable "jh_display_name" {
    description = "Meaningful (long) name of the Jupyter Hub Application"
}

variable "jh_description" {
    description = "Description to be shown for the Jupyter Hub Application"
    default = "Start your notebook and participate in this Jupyter Hub"
}

variable "jh_icon" {
    description = "Icon to show for the Jupyter Hub Application"
    default = "https://raw.githubusercontent.com/jupyterhub/jupyterhub/4.0.0/docs/source/_static/images/logo/favicon.ico"
}

variable "jh_hostname" {
    description = "The hostname of the Jupyter Hub"
}
