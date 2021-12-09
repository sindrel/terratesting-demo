variable "project" {
  description = "The GCP project to create bucket in"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "bucket_suffix" {
  description = "Bucket name suffix"
  type        = string
}

variable "bucket_location" {
  description = "Region or multi-region location where the bucket should be created"
  type        = string
  default     = "EU"
}

variable "role_entity" {
  description = "Sets bucket default object ACLs to allow all users read access to objects"
  type        = list(string)
  default     = ["READER:allUsers"]
}
