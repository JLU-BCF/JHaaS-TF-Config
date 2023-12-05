variable "kubeconfig" {
  description = "Kubernetes configuration file to use"
}

variable "issuer" {
  description = "cluster-issuer to use for ingress"
  default     = "cert-manager"
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
  default     = "default-authentication-flow"
}

variable "authorization_flow" {
  description = "slug name of the authorization workflow to use"
  default     = "default-provider-authorization-implicit-consent"
}

variable "jupyter_notebook_image" {
  description = "The jupyter notebook image to be deployed by the chart."
  default     = "jupyter/minimal-notebook:latest"
}

variable "jupyter_notebook_default_url" {
  description = "Sets the default notebook URL."
  default     = null
}

variable "authentik_jh_group_id" {
  description = "ID of the group that will be bound to the application"
}

variable "jh_display_name" {
  description = "Meaningful (long) name of the Jupyter Hub Application"
}

variable "jh_description" {
  description = "Description to be shown for the Jupyter Hub Application"
  default     = "Start your notebook and participate in this Jupyter Hub"
}

variable "jh_icon" {
  description = "Icon to show for the Jupyter Hub Application"
  default     = "https://raw.githubusercontent.com/jupyterhub/jupyterhub/4.0.0/docs/source/_static/images/logo/favicon.ico"
}

variable "jh_admin_id" {
  description = "If set, contains the ID of the course leader."
  default     = null
}

variable "nb_count_limit" {
  description = "Maximum allowed number of parallel Jupyter Notebooks in the Jupyter Hub"
  default     = "25"
}

variable "nb_home_size" {
  description = "Size of the home directory created for each user notebook"
  default     = "5Gi"
}

variable "nb_home_mount_path" {
  description = "Size of the home directory created for each user notebook"
  default     = "/home/jovyan"
}

variable "nb_ram_guarantee" {
  description = "RAM Guarantee for a single Jupyter Notebook"
  default     = "512Mi"
}

variable "nb_cpu_guarantee" {
  description = "CPU Guarantee for a single Jupyter Notebook"
  default     = "0.25"
}

variable "nb_ram_limit" {
  description = "RAM Limit for a single Jupyter Notebook"
  default     = "2Gi"
}

variable "nb_cpu_limit" {
  description = "CPU Limit for a single Jupyter Notebook"
  default     = "1"
}

variable "ns_ram_limit" {
  description = "RAM Limit for Namespace, user_count x ram_limit + static"
  default     = "55Gi"
}

variable "ns_cpu_limit" {
  description = "value"
  default     = "30"
}

variable "apply_ns_resource_quota" {
  description = "Controls if a resource quota for namespace should be deployed"
  type        = bool
  default     = false
}

variable "jh_api_token" {
  description = "API Token for the JHaaS Portal Service"
  type = string
}
