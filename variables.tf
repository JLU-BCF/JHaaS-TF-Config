variable "kubeconfig" {
    description = "Kubernetes configuration file to use"
}

variable "name" {
    description = "Course / workshow name, will become part of the DNS name"
}

variable "issuer_email" {
    description = "email address to use for certmanager issuer"
}

variable "domain" {
    description = "DNS domain to use for JHaaS deployments"
}

variable "authentik_url" {
    description = "URL of the authentik API"
}

variable "authentik_token" {
    description = "Token to authenticate / authorize at the authentik URL"
}

variable "oidc_id" {
    description = "OIDC client id to use in authentik"
}