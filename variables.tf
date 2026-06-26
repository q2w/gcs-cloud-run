variable "project_id" {
  description = "The Google Cloud Project ID where resources will be deployed"
  type        = string
}

variable "region" {
  description = "The Google Cloud region/location for the resources"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "gcs-mount-demo"
}

variable "bucket_name" {
  description = "The globally unique name for the GCS bucket"
  type        = string
}
