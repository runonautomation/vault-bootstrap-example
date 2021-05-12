variable "approle_backend" {
  description = "Path for APPROLE authentication backend"
}

variable "approle" {
  description = "Name for the application role"
}

variable "accessor" {
  description = "Auth Backend Accessor"
}

variable "meta" {
  default     = {}
  description = "Approle Metadata"
}

variable "policies" {
  default     = []
  description = "Custom policies to add to the application role"
}