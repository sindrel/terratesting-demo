variable "project" {
  description = "The GCP project to deploy to"
  type        = string
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.bucket_name))
    error_message = "The bucket name can only contain lower-case letters, numbers or dashes."
  }
}

variable "bucket_suffix" {
  description = "Bucket name suffix"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.bucket_suffix))
    error_message = "The bucket suffix can only contain lower-case letters, numbers or dashes."
  }
}
