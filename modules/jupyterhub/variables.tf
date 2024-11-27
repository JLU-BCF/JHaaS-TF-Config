variable "name" {
  description = "Name of the course this deployment is used for. Must be a valid DNS name element ([A-Z,a-z,0-9,-]+)"
  nullable    = false
  validation {
    condition     = can(regex("^[A-Za-z0123456789-]+$", var.name))
    error_message = "Name contains invalid characters"
  }
  validation {
    condition     = length(var.name) > 0 && length(var.name) < 64
    error_message = "Name too short or too long (1-63 characters allowed)"
  }
}

variable "helm_chart_version" {
  description = "Version of the helm chart to deploy"
  default     = null
}

variable "jupyter_notebook_image" {
  description = "The jupyter notebook image to be deployed by the chart."
  default     = "jupyter/minimal-notebook:latest"
}

variable "jupyter_notebook_default_url" {
  description = "Sets the default notebook URL."
  default     = null
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

variable "home_directory_size" {
  description = "Size of the home directory created for each user notebook, defaults to 5 GB"
  default     = "5Gi"
}

variable "nb_start_timeout" {
  description = "How long to wait for Notebook before considering startup failed"
  default     = "600"
}

variable "jh_placeholder_replicas" {
  description = "Number of notebook placeholders to maintain"
  default     = "8"
}

variable "jh_concurrent_spawn_limit" {
  description = "Allowed number of concurrent spawning notebooks"
  default     = "32"
}

variable "domain" {
  description = "Domain name to use for deployment. The ingress will be configured with <name>.<domain>"
}

variable "issuer" {
  description = "cluster-issuer to use for ingress"
}

variable "oidc_id" {
  description = "ID of registered OIDC client"
}

variable "oidc_secret" {
  description = "Secret of registered OIDC client"
}

variable "logout_url" {
  description = "URL to redirect to after logout"
}

variable "authorize_url" {
}

variable "token_url" {
}

variable "userdata_url" {
}

variable "login_service" {
}

variable "service_portal_api_token" {
}
