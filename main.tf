terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Create the GCS Bucket using the provided variable
resource "google_storage_bucket" "demo_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true # Allows Terraform to delete the bucket even if it has contents
  uniform_bucket_level_access = true
}

# 2. Create a dedicated Service Account for the Cloud Run service
resource "google_service_account" "cloudrun_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
}

# 3. Grant the Service Account Admin access to the bucket
resource "google_storage_bucket_iam_member" "sa_bucket_access" {
  bucket = google_storage_bucket.demo_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# 4. Deploy Cloud Run (V2) with the GCS Mount
resource "google_cloud_run_v2_service" "demo_service" {
  name     = var.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloudrun_sa.email

    # GCS FUSE requires the Gen2 execution environment
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" 

      # Mount the volume into the container
      volume_mounts {
        name       = "bucket-volume"
        mount_path = "/mnt/my-bucket"
      }
    }

    # Define the GCS volume
    volumes {
      name = "bucket-volume"
      gcs {
        bucket    = google_storage_bucket.demo_bucket.name
        read_only = false
      }
    }
  }

  # Ensure IAM permissions are attached before the service tries to mount the bucket
  depends_on = [google_storage_bucket_iam_member.sa_bucket_access]
}

# 5. Make the Cloud Run service publicly accessible (for demo purposes)
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.demo_service.location
  service  = google_cloud_run_v2_service.demo_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

module loc_mod {
  source = "./modules/mod1"
  service_name = "${var.service_name}-1"
  region = var.region
}

# Output the URL of the deployed service
output "cloud_run_url" {
  value       = google_cloud_run_v2_service.demo_service.uri
  description = "The URL to access the deployed Cloud Run service"
}
