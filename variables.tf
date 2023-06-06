variable "kubeconfig" {
    description = "Kubernetes configuration file to use"
}

variable "issuer" {
    description = "cluster-issuer to use for ingress"
    default = "cert-manager"
}

variable "name" {
    description = "Course / workshow name, will become part of the DNS name"
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

variable "authentication_flow" {
    description = "slug name of the authentication workflow to use"
    default = "default-authentication-flow"
}

variable "authorization_flow" {
    description = "slug name of the authorization workflow to use"
    default = "default-provider-authorization-implicit-consent"
}

variable "jupyter_notebook_image" {
  description = "The jupyter notebook image to be deployed by the chart."
  default = "jupyter/minimal-notebook:latest"
}
