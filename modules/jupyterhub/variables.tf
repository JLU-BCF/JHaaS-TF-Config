variable "name" {
  description = "Name of the course this deployment is used for. Must be a valid DNS name element ([A-Z,a-z,0-9,-]+)"
  nullable = false
  validation {
    condition = can(regex("^[A-Za-z0123456789-]+$", var.name))
    error_message = "Name contains invalid characters"
  }
  validation {
    condition = length(var.name) > 0 && length(var.name) < 64
    error_message = "Name too short or too long (1-63 characters allowed)"
  }
}

variable "helm_chart_version" {
  description = "Version of the helm chart to deploy"
  default = "2.0.0"
}

variable "jupyter_notebook_image" {
  description = "The jupyter notebook image to be deployed by the chart."
  default = "jupyter/minimal-notebook:latest"
}

variable "spawner_memory_limit" {
  description = "Memory limit for user notebook pods, defaults to 1 GB"
  default = "1G"
}

variable "spawner_cpu_share" {
  description = "CPU share limit of user notebook pods, defaults to 0.5"
  default = 0.5
  type = number
}

variable "home_directory_size" {
  description = "Size of the home directory created for each user notebook, defaults to 5 GB"
  default = "5Gi"
}
