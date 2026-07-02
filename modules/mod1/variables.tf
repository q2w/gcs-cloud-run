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