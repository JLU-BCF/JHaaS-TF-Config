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