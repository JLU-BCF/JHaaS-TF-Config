variable "chart_filebrowser_version" {
  type        = string
  description = ""
}

variable "jhaas_namespace" {
  type        = string
  description = "description"
}

variable "filebrowser_name" {
  type        = string
  description = "description"
}

variable "filebrowser_display_name" {
  type        = string
  description = "description"
}

variable "filebrowser_description" {
  type        = string
  description = "description"
}

variable "filebrowser_hostname" {
  type        = string
  description = "description"
}

variable "filebrowser_group_name" {
  type        = string
  default     = "Filebrowsers"
  description = "description"
}

variable "extra_volumes" {
  type        = list(any)
  default     = []
  description = "description"
}

variable "extra_volume_mounts" {
  type        = list(any)
  default     = []
  description = "description"
}

variable "volume_sources" {
  type        = list(any)
  default     = []
  description = "description"
}

variable "filebrowser_oidc_issuer" {
  type        = string
  description = "description"
}

variable "filebrowser_oidc_client" {
  type        = string
  description = "description"
}

variable "filebrowser_oidc_logout_url" {
  type        = string
  description = "description"
}

# # GENERATED!
# variable filebrowser_oidc_secret {
#   type        = string
#   default     = ""
#   description = "description"
# }

variable "filebrowser_redirect_uri" {
  description = "Valid redirection URL for client"
  type        = string
}

variable "authentication_flow" {
  description = "slug name of the authentication workflow to use"
  default     = "auth"
}

variable "authorization_flow" {
  description = "slug name of the authorization workflow to use"
  default     = "consent"
}

variable "invalidation_flow" {
  description = "slug name of the invalidation workflow to use"
  default     = "logout"
}
