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