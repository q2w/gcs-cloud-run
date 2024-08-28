variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_iam_members" {
  type = list(object({ role : string }))
}

variable "bucket_force_destroy" {
    type = bool
    default = true
}

variable "cloud_run_service_name" {
  type = string
}

variable "cloud_run_containers" {
  type = list(object({ container_image : string, volume_mounts : list(object({ name : string, mount_path : string })) }))
}

variable "cloud_run_volumes" {
  type = list(object({ name : string }))
}