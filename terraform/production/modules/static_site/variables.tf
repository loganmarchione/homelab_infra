variable "bucket_name" {
  description = "Name of the site bucket to be created in S3"
  type        = string

  validation {
    condition = (
      var.bucket_name != "" &&
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "S3 bucket name contains invalid characters"
  }
}

variable "bucket_versioning" {
  default     = "Disabled"
  description = "State of bucket versioning"
  type        = string

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.bucket_versioning)
    error_message = "Variable must be 'Enabled', 'Suspended', or 'Disabled'"
  }
}

variable "site_name" {
  description = "Name of the site (e.g., example.com)"
  type        = string
}
